require 'net/https'
require 'uri'
require 'cgi'
require 'json'

module ConvertApi
  class Client
    NET_HTTP_EXCEPTIONS = [
      IOError,
      Errno::ECONNABORTED,
      Errno::ECONNREFUSED,
      Errno::ECONNRESET,
      Errno::EHOSTUNREACH,
      Errno::EINVAL,
      Errno::ENETUNREACH,
      Errno::EPIPE,
      Net::HTTPBadResponse,
      Net::HTTPHeaderSyntaxError,
      Net::ProtocolError,
      SocketError,
      Zlib::GzipFile::Error,
    ]

    USER_AGENT = "ConvertAPI-Ruby/#{VERSION}"

    DEFAULT_HEADERS = {
      'User-Agent' => USER_AGENT,
      'Accept' => 'application/json'
    }

    # Parameters that are always on the URL, even for POST
    POST_URL_PARAMS = [
      :WebHook,
      :JobId
    ].freeze

    def get(path, params = {}, options = {})
      handle_response do
        request = Net::HTTP::Get.new(request_uri(path, params), DEFAULT_HEADERS)

        http(options).request(request)
      end
    end

    def post(path, params, options = {})
      handle_response do
        request = Net::HTTP::Post.new(request_uri(path, post_url_params(params)), DEFAULT_HEADERS)
        request.form_data = build_form_data(params)

        http(options).request(request)
      end
    end

    def upload(io, filename)
      handle_response do
        request_uri = base_uri.path + 'upload'
        encoded_filename = CGI.escape(filename)

        headers = DEFAULT_HEADERS.merge(
          'Content-Type' => 'application/octet-stream',
          'Transfer-Encoding' => 'chunked',
          'Content-Disposition' => "attachment; filename*=UTF-8''#{encoded_filename}",
        )

        request = Net::HTTP::Post.new(request_uri, headers)
        request.body_stream = io

        http(read_timeout: config.upload_timeout).request(request)
      end
    end

    private

    def handle_response
      handle_http_exceptions do
        response = yield
        status = response.code.to_i

        if status != 200
          raise(
            ClientError,
            status: status,
            body: response.body,
            headers: response.each_header.to_h,
          )
        end

        JSON.parse(response.body)
      end
    end

    def handle_http_exceptions
      yield
    rescue *NET_HTTP_EXCEPTIONS => e
      raise(ConnectionFailed, e)
    rescue Timeout::Error, Errno::ETIMEDOUT => e
      raise(TimeoutError, e)
    end

    def http(options = {})
      http = Net::HTTP.new(base_uri.host, base_uri.port)
      http.open_timeout = config.connect_timeout
      http.read_timeout = options.fetch(:read_timeout, config.read_timeout)
      http.use_ssl = base_uri.scheme == 'https'
      # http.set_debug_output $stderr
      http
    end

    def request_uri(path, params = {})
      raise(SecretError, 'API secret not configured') if config.api_secret.nil?

      params_with_secret = params.merge(Secret: config.api_secret)
      query = URI.encode_www_form(params_with_secret)

      base_uri.path + path + '?' + query
    end

    def build_form_data(params)
      data = {}

      params.each do |key, value|
        unless POST_URL_PARAMS.include?(key)
          if value.is_a?(Array)
            value.each_with_index { |v, i| data["#{key}[#{i}]"] = v }
          else
            data[key] = value
          end
        end
      end

      data
    end

    def post_url_params(params)
      params.select { |k, v| POST_URL_PARAMS.include?(k) }
    end

    def base_uri
      config.base_uri
    end

    def config
      ConvertApi.config
    end
  end
end

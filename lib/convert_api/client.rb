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

    def post(path, params, options = {})
      handle_response do
        headers = { 'Accept' => 'application/json' }
        request = Net::HTTP::Post.new(uri_with_secret(path), headers)
        request.form_data = build_form_data(params)

        http(options).request(request)
      end
    end

    def upload(io, filename)
      handle_response do
        encoded_filename = URI.encode(filename)

        headers = {
          'Content-Type' => 'application/octet-stream',
          'Accept' => 'application/json',
          'Transfer-Encoding' => 'chunked',
          'Content-Disposition' => "attachment; filename*=UTF-8''#{encoded_filename}",
        }

        request = Net::HTTP::Post.new('/upload', headers)
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

    def http(read_timeout: nil)
      http = Net::HTTP.new(base_uri.host, base_uri.port)
      http.open_timeout = config.connect_timeout
      http.read_timeout = read_timeout || config.read_timeout
      http.use_ssl = base_uri.scheme == 'https'
      # http.set_debug_output $stderr
      http
    end

    def base_uri
      @base_uri ||= URI(config.api_base_uri)
    end

    def uri_with_secret(path)
      raise(SecretError, 'API secret not configured') if config.api_secret.nil?

      path + '?Secret=' + CGI.escape(config.api_secret)
    end

    def build_form_data(params)
      data = {}

      params.each do |key, value|
        if value.is_a?(Array)
          value.each_with_index { |v, i| data["#{key}[#{i}]"] = v }
        else
          data[key] = value
        end
      end

      data
    end

    def config
      ConvertApi.config
    end
  end
end

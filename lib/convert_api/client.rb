require 'faraday'
require 'faraday_middleware'
require 'open-uri'

module ConvertApi
  class Client
    def post(path, params)
      handle_exceptions do
        connection.post(path, params).body
      end
    end

    def upload(io, filename)
      handle_exceptions do
        result = connection.post('upload', io.read) do |request|
          request.headers['Content-Type'] = 'application/octet-stream'
          request.headers['Content-Disposition'] = "attachment; filename='#{filename}'"
        end

        result.body
      end
    end

    def download(url, path)
      io = open(url, open_timeout: config.connect_timeout, read_timeout: config.download_timeout)

      IO.copy_stream(io, path)

      path
    rescue Net::ReadTimeout
      raise(DownloadTimeoutError, 'Download timeout')
    end

    private

    def handle_exceptions
      yield
    rescue Faraday::ClientError => e
      raise(ClientError, e.response)
    end

    def connection
      @connection = Faraday.new(url: config.api_base_uri) do |builder|
        builder.options[:timeout] = config.request_timeout
        builder.options[:open_timeout] = config.connect_timeout

        builder.headers['Accept'] = 'application/json'

        builder.params['Secret'] = config.api_secret
        builder.params['TimeOut'] = config.conversion_timeout
        builder.params['StoreFile'] = true

        builder.request :url_encoded

        builder.response :json, content_type: /\bjson$/
        builder.response :raise_error

        builder.adapter Faraday.default_adapter
      end
    end

    def config
      ConvertApi.config
    end
  end
end

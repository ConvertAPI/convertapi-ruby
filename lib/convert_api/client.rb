require 'faraday'
require 'faraday_middleware'

module ConvertApi
  class Client
    def post(path, params)
      handle_exceptions do
        connection.post(path, params).body
      end
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

        builder.request :multipart
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

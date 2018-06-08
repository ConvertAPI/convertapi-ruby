module ConvertApi
  class Configuration
    HTTP_REQUEST_TIMEOUT_DELTA = 10

    attr_accessor :api_secret
    attr_accessor :api_base_uri
    attr_accessor :connect_timeout
    attr_accessor :conversion_timeout
    attr_accessor :upload_timeout
    attr_accessor :download_timeout
    attr_accessor :url_formats

    def initialize
      @api_base_uri = 'https://v2.convertapi.com'
      @connect_timeout = 5
      @conversion_timeout = 600
      @upload_timeout = 600
      @download_timeout = 600
      @url_formats = %w[url web]
    end

    def request_timeout
      conversion_timeout + HTTP_REQUEST_TIMEOUT_DELTA
    end
  end
end

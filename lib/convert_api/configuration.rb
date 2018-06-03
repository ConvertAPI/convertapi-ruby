module ConvertApi
  class Configuration
    attr_accessor :api_secret
    attr_accessor :api_base_uri
    attr_accessor :request_timeout
    attr_accessor :upload_timeout
    attr_accessor :download_timeout

    def initialize
      @api_base_uri = 'https://v2.convertapi.com'
      @request_timeout = 600
      @upload_timeout = 600
      @download_timeout = 600
    end
  end
end

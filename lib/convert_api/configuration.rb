module ConvertApi
  class Configuration
    attr_accessor :api_credentials
    attr_accessor :base_uri
    attr_accessor :connect_timeout
    attr_accessor :read_timeout
    attr_accessor :conversion_timeout
    attr_accessor :conversion_timeout_delta
    attr_accessor :upload_timeout
    attr_accessor :download_timeout

    def initialize
      @base_uri = URI('https://v2.convertapi.com/')
      @connect_timeout = 5
      @read_timeout = 1800
      @conversion_timeout_delta = 10
      @upload_timeout = 1800
      @download_timeout = 1800
    end
  end
end

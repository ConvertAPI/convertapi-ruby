require 'open-uri'

module ConvertApi
  class ResultFile
    attr_reader :info

    def initialize(info)
      @info = info
    end

    def url
      info['Url']
    end

    def filename
      info['FileName']
    end

    def size
      info['FileSize']
    end

    def io
      @io ||= URI.parse(url).open(download_options)
    end

    def save(path)
      path = File.join(path, filename) if File.directory?(path)

      IO.copy_stream(io, path, size)

      path
    end

    private

    def download_options
      options = { read_timeout: config.download_timeout }

      options[:open_timeout] = config.connect_timeout if RUBY_VERSION > '2.2.0'

      options.merge('User-Agent' => ConvertApi::Client::USER_AGENT)
    end

    def config
      ConvertApi.config
    end
  end
end

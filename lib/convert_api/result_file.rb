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
      @io ||= open(
        url,
        open_timeout: config.connect_timeout,
        read_timeout: config.download_timeout,
      )
    end

    def save(path)
      path = File.join(path, filename) if File.directory?(path)

      IO.copy_stream(io, path, size)

      path
    end

    private

    def config
      ConvertApi.config
    end
  end
end

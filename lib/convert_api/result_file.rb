require 'open-uri'

module ConvertApi
  class ResultFile
    attr_reader :file_info

    def initialize(file_info)
      @file_info = file_info
    end

    def url
      file_info['Url']
    end

    def filename
      file_info['FileName']
    end

    def size
      file_info['FileSize']
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

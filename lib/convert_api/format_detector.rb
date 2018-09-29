module ConvertApi
  class FormatDetector
    def initialize(resource)
      @resource = resource
    end

    def run
      return @resource.file_ext.downcase if @resource.is_a?(UploadIO)

      format_from_path
    end

    private

    def format_from_path
      extension = File.extname(path).downcase
      format = extension[1..-1]
      format || raise(FormatError, 'Unable to detect format')
    end

    def path
      case @resource
      when String
        URI(@resource).path
      when File
        @resource.path
      else
        ''
      end
    end
  end
end

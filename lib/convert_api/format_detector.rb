module ConvertApi
  class FormatDetector
    ANY_FORMAT = 'any'

    def initialize(resource, to_format)
      @resource = resource
      @to_format = to_format
    end

    def run
      return ANY_FORMAT if archive?
      return @resource.file_ext.downcase if @resource.is_a?(UploadIO)

      format_from_path || raise(FormatError, 'Unable to detect format')
    end

    private

    def archive?
      @to_format.to_s.downcase == 'zip'
    end

    def format_from_path
      extension = File.extname(path).downcase
      extension[1..-1]
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

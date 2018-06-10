module ConvertApi
  class FormatDetector
    DEFAULT_URL_FORMAT = 'url'

    def initialize(resource)
      @resource = resource
    end

    def run
      extension = File.extname(path).downcase

      return DEFAULT_URL_FORMAT if extension.empty? && @resource =~ URI_REGEXP

      format = extension[1..-1]

      raise(FormatError, 'Unable to detect format') if format.nil?

      format
    end

    private

    def path
      case @resource
      when String
        URI(@resource).path
      when File
        @resource.path
      when UploadIO
        @resource.filename
      else
        ''
      end
    end
  end
end

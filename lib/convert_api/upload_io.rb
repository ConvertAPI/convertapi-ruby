require 'uri'

module ConvertApi
  class UploadIO
    URI_REGEXP = URI::regexp(%w(http https))

    def initialize(resource, filename = nil)
      @resource = resource
      @filename = filename
    end

    def to_s
      return @resource if @resource =~ URI_REGEXP

      result = ConvertApi.client.upload(io, filename)
      result['FileId']
    end

    private

    def io
      return @resource if @resource.respond_to?(:read)

      @io ||= File.open(@resource)
    end

    def filename
      @filename || io_filename || raise(FileNameError, 'IO filename must be provided')
    end

    def io_filename
      return unless io.respond_to?(:path)

      File.basename(io.path)
    end
  end
end

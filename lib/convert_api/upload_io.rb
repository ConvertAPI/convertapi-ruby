require 'uri'

module ConvertApi
  class UploadIO
    attr_reader :io, :filename

    def initialize(io, filename = nil)
      @io = io
      @filename = filename || io_filename || raise(FileNameError, 'IO filename must be provided')
    end

    def to_s
      result = ConvertApi.client.upload(io, filename)
      result['FileId']
    end

    private

    def io_filename
      return unless io.respond_to?(:path)
      File.basename(io.path)
    end
  end
end

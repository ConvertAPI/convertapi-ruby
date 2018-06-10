require 'uri'

module ConvertApi
  class UploadIO
    attr_reader :io, :filename

    def initialize(io, filename = nil)
      @io = io
      @filename = filename || io_filename || raise(FileNameError, 'IO filename must be provided')
    end

    def to_s
      file_id
    end

    private

    def file_id
      @file_id ||= upload_file['FileId']
    end

    def upload_file
      ConvertApi.client.upload(io, filename)
    end

    def io_filename
      return unless io.respond_to?(:path)
      File.basename(io.path)
    end
  end
end

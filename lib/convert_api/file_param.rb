module ConvertApi
  module FileParam
    module_function

    def build(value)
      case value
      when UploadIO, URI_REGEXP
        value
      when Result
        value.file.url
      when ResultFile
        value.url
      when IO
        UploadIO.new(value)
      else
        UploadIO.new(File.open(value))
      end
    end
  end
end

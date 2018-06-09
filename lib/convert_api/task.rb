module ConvertApi
  class Task
    attr_reader :from_format, :to_format, :resource, :options

    def initialize(resource, to_format, from_format, options = {})
      @resource = resource
      @to_format = to_format
      @from_format = from_format || detect_format
      @options = options
    end

    def result
      response = ConvertApi.client.post("/#{from_format}/to/#{to_format}", conversion_params)

      Result.new(response)
    end

    private

    def detect_format
      FormatDetector.new(Array(resource).first).run
    end

    def conversion_params
      options
        .merge(
          Timeout: config.conversion_timeout,
          StoreFile: true,
        )
        .merge(file_params)
    end

    def file_params
      result = {}

      if resource.is_a?(Array)
        resource.each_with_index do |r, i|
          result["Files[#{i}]"] = upload_io(r)
        end
      elsif config.url_formats.include?(from_format)
        result['Url'] = resource
      else
        result['File'] = upload_io(resource)
      end

      result
    end

    def upload_io(resource)
      return resource if resource.is_a?(UploadIO)

      UploadIO.new(resource)
    end

    def config
      ConvertApi.config
    end
  end
end

module ConvertApi
  class Task
    attr_reader :from_format, :to_format, :resource, :params

    def initialize(from_format, to_format, resource, params = {})
      @from_format = from_format
      @to_format = to_format
      @resource = resource
      @params = params
    end

    def result
      Result.new(response)
    end

    private

    def response
      ConvertApi.client.post(
        "/#{from_format}/to/#{to_format}",
        conversion_params
      )
    end

    def conversion_params
      params
        .merge(
          TimeOut: ConvertApi.config.conversion_timeout,
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
      else
        result['File'] = upload_io(resource)
      end

      result
    end

    def upload_io(resource)
      return resource if resource.is_a?(UploadIO)

      UploadIO.new(resource)
    end
  end
end

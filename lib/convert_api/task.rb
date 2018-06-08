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
      ConvertApi.client.post(path, conversion_params)
    end

    def path
      "/#{from_format}/to/#{to_format}"
    end

    def conversion_params
      params
        .merge(
          TimeOut: ConvertApi.config.conversion_timeout,
          StoreFile: true,
        )
        .merge(file_param)
    end

    def file_param
      if resource.is_a?(Array)
        { Files: resource.map { |r| upload_io(r) } }
      else
        { File: upload_io(resource) }
      end
    end

    def upload_io(resource)
      return resource if resource.is_a?(UploadIO)

      UploadIO.new(resource)
    end
  end
end

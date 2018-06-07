module ConvertApi
  class Result
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def conversion_cost
      response['ConversionCost']
    end

    def urls
      response['Files'].map{ |file_info| file_info['Url'] }
    end

    def save_files(path)
      response['Files'].map do |file_info|
        save_file(path, file_info)
      end
    end

    private

    def save_file(path, file_info)
      file_path = File.join(path, file_info['FileName'])

      ConvertApi.client.download(file_info['Url'], file_path)
    end
  end
end

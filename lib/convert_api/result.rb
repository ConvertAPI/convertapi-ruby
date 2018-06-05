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
      response['Files'].map{ |file| file['Url'] }
    end
  end
end

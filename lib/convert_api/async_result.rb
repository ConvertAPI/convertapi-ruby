module ConvertApi
  class AsyncResult
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def job_id
      response['JobId']
    end
  end
end

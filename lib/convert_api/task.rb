module ConvertApi
  class Task
    attr_reader :from_format, :to_format, :params

    def initialize(from_format, to_format, params)
      @from_format = from_format
      @to_format = to_format
      @params = params
    end

    def result
      @result ||= ConvertApi.client.post(path, params)
    end

    private

    def path
      "#{from_format}/to/#{to_format}"
    end
  end
end

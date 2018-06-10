module ConvertApi
  class Task
    attr_reader :from_format, :to_format, :params

    def initialize(from_format, to_format, params)
      @params = symbolize_keys(params)
      @to_format = to_format
      @from_format = from_format || detect_format
    end

    def result
      response = ConvertApi.client.post("/#{from_format}/to/#{to_format}", conversion_params)

      Result.new(response)
    end

    private

    def detect_format
      FormatDetector.new(first_resource).run
    end

    def conversion_params
      result = {
        Timeout: config.conversion_timeout,
        StoreFile: true,
      }

      params.each do |key, value|
        case key
        when :File
          result[:File] = upload_io(value)
        when :Files
          Array(value) do |r, i|
            result["Files[#{i}]"] = upload_io(r)
          end
        else
          result[key] ||= value
        end
      end

      result
    end

    def first_resource
      params[:File] || params[:Url] || Array(params[:Files]).first
    end

    def symbolize_keys(hash)
      hash.map { |k, v| [k.to_sym, v] }.to_h
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

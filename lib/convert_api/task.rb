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
      resource = params[:File] || params[:Url] || Array(params[:Files]).first

      FormatDetector.new(resource).run
    end

    def conversion_params
      result = {
        Timeout: config.conversion_timeout,
        StoreFile: true,
      }

      params.each do |key, value|
        case key
        when :File
          result[:File] = file_param(value)
        when :Files
          Array(value) do |r, i|
            result["Files[#{i}]"] = file_param(r)
          end
        else
          result[key] ||= value
        end
      end

      result
    end

    def symbolize_keys(hash)
      hash.map { |k, v| [k.to_sym, v] }.to_h
    end

    def file_param(value)
      case value
      when UploadIO, URI_REGEXP
        value
      when IO
        UploadIO.new(value)
      else
        UploadIO.new(File.open(value))
      end
    end

    def config
      ConvertApi.config
    end
  end
end

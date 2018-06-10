module ConvertApi
  class Task
    attr_reader :from_format, :to_format, :params

    def initialize(from_format, to_format, params)
      @params = normalize_params(params)
      @to_format = to_format
      @from_format = from_format || detect_format
    end

    def result
      request_params = params.merge(
        Timeout: config.conversion_timeout,
        StoreFile: true,
      )

      response = ConvertApi.client.post("/#{from_format}/to/#{to_format}", request_params)

      Result.new(response)
    end

    private

    def normalize_params(params)
      result = {}

      symbolize_keys(params).each do |key, value|
        case key
        when :File
          result[:File] = file_param(value)
        when :Files
          result[:Files] = Array(result[:Files]).map { |file| file_param(file) }
        else
          result[key] = value
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

    def detect_format
      resource = params[:File] || params[:Url] || Array(params[:Files]).first

      FormatDetector.new(resource).run
    end

    def config
      ConvertApi.config
    end
  end
end

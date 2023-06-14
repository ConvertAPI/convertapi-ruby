module ConvertApi
  class Task
    def initialize(from_format, to_format, params, conversion_timeout: nil)
      @from_format = from_format
      @to_format = to_format
      @conversion_timeout = conversion_timeout || config.conversion_timeout
      @params = normalize_params(params).merge(
        Timeout: @conversion_timeout,
        StoreFile: true,
      )
      @async = @params.delete(:Async)
      @converter = detect_converter
    end

    attr_reader :converter

    def run
      read_timeout = @conversion_timeout + config.conversion_timeout_delta if @conversion_timeout

      response = ConvertApi.client.post(
        request_path,
        @params,
        read_timeout: read_timeout,
      )

      return AsyncResult.new(response) if async?

      Result.new(response)
    end

    private

    def async?
      @async.to_s.downcase == 'true'
    end

    def request_path
      from_format = @from_format || detect_format
      converter_path = converter ? "/converter/#{converter}" : ''
      async = async? ? 'async/' : ''

      "#{async}convert/#{from_format}/to/#{@to_format}#{converter_path}"
    end

    def normalize_params(params)
      result = {}

      symbolize_keys(params).each do |key, value|
        case
        when key != :StoreFile && key.to_s.end_with?('File')
          result[key] = FileParam.build(value)
        when key == :Files
          result[:Files] = files_batch(value)
        else
          result[key] = value
        end
      end

      result
    end

    def symbolize_keys(hash)
      hash.map { |k, v| [k.to_sym, v] }.to_h
    end

    def files_batch(values)
      files = Array(values).map { |file| FileParam.build(file) }

      # upload files in parallel
      files
        .select { |file| file.is_a?(UploadIO) }
        .map { |upload_io| Thread.new { upload_io.file_id } }
        .map(&:join)

      files
    end

    def detect_format
      return DEFAULT_URL_FORMAT if @params[:Url]

      resource = @params[:File] || Array(@params[:Files]).first

      FormatDetector.new(resource, @to_format).run
    end

    def detect_converter
      @params.each do |key, value|
        return value if key.to_s.downcase == 'converter'
      end

      nil
    end

    def config
      ConvertApi.config
    end
  end
end

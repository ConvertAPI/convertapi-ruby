module ConvertApi
  class Error < StandardError; end
  class AuthenticationError < Error; end
  class FileNameError < Error; end
  class TimeoutError < Error; end
  class ConnectionFailed < Error; end
  class FormatError < Error; end

  class ClientError < Error
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def to_s
      return "the server responded with status #{http_status}" unless json?

      "#{error_message} Code: #{code}. #{invalid_parameters}".strip
    end

    def error_message
      response_json['Message']
    end

    def code
      response_json['Code']
    end

    def invalid_parameters
      response_json['InvalidParameters']
    end

    def http_status
      response[:status]
    end

    def response_json
      @response_json ||= begin
        JSON.parse(response[:body])
      rescue JSON::ParserError
        {}
      end
    end

    private

    def json?
      response[:headers]['content-type'] =~ /json/
    end
  end
end

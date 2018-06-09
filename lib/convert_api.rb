require 'convert_api/version'
require 'convert_api/configuration'
require 'convert_api/task'
require 'convert_api/client'
require 'convert_api/errors'
require 'convert_api/result'
require 'convert_api/result_file'
require 'convert_api/upload_io'
require 'convert_api/format_detector'

module ConvertApi
  URI_REGEXP = URI::regexp(%w(http https))

  module_function

  def configure
    yield(config)
  end

  def config
    @config ||= Configuration.new
  end

  def convert(resource, to_format, from_format = nil, options = {})
    Task.new(resource, to_format, from_format, options).result
  end

  def client
    @client ||= Client.new
  end
end

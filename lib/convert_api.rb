require 'convert_api/version'
require 'convert_api/configuration'
require 'convert_api/task'
require 'convert_api/client'
require 'convert_api/errors'
require 'convert_api/result'
require 'convert_api/upload_io'

module ConvertApi
  module_function

  def configure
    yield(config)
  end

  def config
    @config ||= Configuration.new
  end

  def convert(from_format, to_format, resource, params = {})
    Task.new(from_format, to_format, resource, params).result
  end

  def client
    @client ||= Client.new
  end
end

require 'convert_api/version'
require 'convert_api/configuration'
require 'convert_api/task'
require 'convert_api/client'
require 'convert_api/errors'

module ConvertApi
  module_function

  def configure
    yield(config)
  end

  def config
    @config ||= Configuration.new
  end

  def convert_async(from_format, to_format, params)
    Task.new(from_format, to_format, params)
  end

  def client
    @client ||= Client.new
  end
end

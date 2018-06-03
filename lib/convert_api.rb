require 'convert_api/version'
require 'convert_api/configuration'

module ConvertApi
  module_function

  def configure
    yield(config)
  end

  def config
    @config ||= Configuration.new
  end
end

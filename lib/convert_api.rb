require 'convert_api/version'
require 'convert_api/configuration'
require 'convert_api/task'
require 'convert_api/client'
require 'convert_api/errors'
require 'convert_api/result'
require 'convert_api/result_file'
require 'convert_api/upload_io'
require 'convert_api/file_param'
require 'convert_api/format_detector'

module ConvertApi
  URI_REGEXP = URI::regexp(%w(http https))
  DEFAULT_URL_FORMAT = 'url'

  module_function

  def configure
    yield(config)
  end

  def config
    @config ||= Configuration.new
  end

  def convert(to_format, params, from_format: nil, conversion_timeout: nil)
    Task.new(from_format, to_format, params, conversion_timeout: conversion_timeout).run
  end

  def user
    client.get('user')
  end

  def client
    Thread.current[:convert_api_client] ||= Client.new
  end
end

require 'bundler/setup'
require 'convert_api'

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    ConvertApi.config.api_secret = ENV['CONVERT_API_SECRET']
    # or
    ConvertApi.config.token = ENV['CONVERT_API_TOKEN']
  end
end

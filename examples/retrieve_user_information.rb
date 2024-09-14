require 'convert_api'

ConvertApi.configure do |config|
  config.api_credentials = ENV['CONVERT_API_SECRET'] # your api secret or token
end

# Retrieve user information
# https://www.convertapi.com/doc/user

puts ConvertApi.user

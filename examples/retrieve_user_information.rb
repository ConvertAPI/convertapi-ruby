require 'convert_api'

ConvertApi.configure do |config|
  config.api_secret = ENV['CONVERT_API_SECRET'] # your api secret
  # or
  config.token = ENV['CONVERT_API_TOKEN'] # your token
end

# Retrieve user information
# https://www.convertapi.com/doc/user

puts ConvertApi.user

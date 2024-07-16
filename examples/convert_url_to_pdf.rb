require 'convert_api'
require 'tmpdir'

ConvertApi.configure do |config|
  config.api_secret = ENV['CONVERT_API_SECRET'] # your api secret
  # or
  config.token = ENV['CONVERT_API_TOKEN'] # your token
end
# Example of converting Web Page URL to PDF file
# https://www.convertapi.com/web-to-pdf

result = ConvertApi.convert(
  'pdf',
  {
    Url: 'https://en.wikipedia.org/wiki/Data_conversion',
    FileName: 'web-example'
  },
  from_format: 'web',
  conversion_timeout: 180,
)

saved_files = result.save_files(Dir.tmpdir)

puts "The web page PDF saved to #{saved_files}"

require 'convert_api'
require 'tmpdir'

ConvertApi.configure do |config|
  config.api_secret = ENV['CONVERT_API_SECRET'] # your api secret
end

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

puts "File saved: #{saved_files}"

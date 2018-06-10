require 'convert_api'
require 'tmpdir'

ConvertApi.configure do |config|
  config.api_secret = ENV['CONVERT_API_SECRET'] # your api secret
end

pdf_result = ConvertApi.convert(
  'extract',
  File: 'files/test.pdf',
  PageRange: 1,
)

jpg_result = ConvertApi.convert(
  'jpg',
  File: pdf_result,
  ScaleImage: true,
  ScaleProportions: true,
  ImageHeight: 300,
  ImageWidth: 300,
)

saved_files = jpg_result.save_files(Dir.tmpdir)

puts "The thumbnail saved to #{saved_files}"

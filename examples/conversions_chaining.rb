require 'convert_api'
require 'tmpdir'

ConvertApi.configure do |config|
  config.api_secret = ENV['CONVERT_API_SECRET'] # your api secret
end

# Short example of conversions chaining, the PDF pages extracted and saved as separated JPGs and then ZIP'ed
# https://www.convertapi.com/doc/chaining

puts 'Converting PDF to JPG and compressing result files with ZIP'

jpg_result = ConvertApi.convert('jpg', {File: 'files/test.pdf'})

puts "Conversions done. Cost: #{jpg_result.conversion_cost}. Total files created: #{jpg_result.files.count}"

zip_result = ConvertApi.convert('zip', Files: jpg_result.files)

puts "Conversions done. Cost: #{zip_result.conversion_cost}. Total files created: #{zip_result.files.count}"

saved_files = zip_result.save_files(Dir.tmpdir)

puts "File saved to #{saved_files}"

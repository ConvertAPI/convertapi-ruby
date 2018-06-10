require 'convert_api'
require 'tmpdir'

ConvertApi.configure do |config|
  config.api_secret = ENV['CONVERT_API_SECRET'] # your api secret
end

# Use upload IO wrapper to upload file only once to the API
upload_io = ConvertApi::UploadIO.new(File.open('files/test.docx'))

saved_files = ConvertApi
  .convert('pdf', File: upload_io)
  .save_files(Dir.tmpdir)

puts "The PDF saved to: #{saved_files}"

# Reuse the same uploaded file
saved_files = ConvertApi
  .convert('png', File: upload_io)
  .save_files(Dir.tmpdir)

puts "The PNG saved to: #{saved_files}"

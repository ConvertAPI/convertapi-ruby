require 'convert_api'
require 'tmpdir'

ConvertApi.configure do |config|
  config.api_secret = ENV['CONVERT_API_SECRET'] # your api secret
end

# Example of converting text to PDF
# https://www.convertapi.com/txt-to-pdf

content = 'Test file body'

io = StringIO.new
io.write(content)
io.rewind

# Use upload IO wrapper to upload data to the API
upload_io = ConvertApi::UploadIO.new(io, 'test.txt')

saved_files = ConvertApi
  .convert('pdf', File: upload_io)
  .save_files(Dir.tmpdir)

puts "The PDF saved to: #{saved_files}"

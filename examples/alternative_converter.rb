require 'convert_api'
require 'tmpdir'

ConvertApi.configure do |config|
  config.api_secret = ENV['CONVERT_API_SECRET'] # your api secret
  # or
  config.token = ENV['CONVERT_API_TOKEN'] # your token
end

# Example of saving Word docx to PDF using OpenOffice converter
# https://www.convertapi.com/doc-to-pdf/openoffice

# Use upload IO wrapper to upload file only once to the API
upload_io = ConvertApi::UploadIO.new(File.open('files/test.docx'))

saved_files = ConvertApi
  .convert('pdf', {File: upload_io, converter: 'openofficetopdf'})
  .save_files(Dir.tmpdir)

puts "The PDF saved to: #{saved_files}"

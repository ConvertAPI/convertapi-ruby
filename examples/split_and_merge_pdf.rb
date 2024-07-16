require 'convert_api'
require 'tmpdir'

ConvertApi.configure do |config|
  config.api_secret = ENV['CONVERT_API_SECRET'] # your api secret
  # or
  config.token = ENV['CONVERT_API_TOKEN'] # your token
end

# Example of extracting first and last pages from PDF and then merging them back to new PDF.
# https://www.convertapi.com/pdf-to-split
# https://www.convertapi.com/pdf-to-merge

split_result = ConvertApi.convert('split', {File: 'files/test.pdf'})

files = [split_result.files.first, split_result.files.last]

merge_result = ConvertApi.convert('merge', {Files: files})

saved_files = merge_result.save_files(Dir.tmpdir)

puts "The PDF saved to #{saved_files}"

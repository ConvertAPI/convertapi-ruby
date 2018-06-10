# ConvertAPI Ruby Client
## Convert your files with our online file conversion API

The ConvertAPI helps converting various file formats. Creating PDF and Images from various sources like Word, Excel, Powerpoint, images, web pages or raw HTML codes. Merge, Encrypt, Split, Repair and Decrypt PDF files. And many others files manipulations. In just few minutes you can integrate it into your application and use it easily.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'convert_api'
```

## Usage

### Configuration

You can get your secret at https://www.convertapi.com/a

```ruby
ConvertApi.configure do |config|
  config.api_secret = 'your api secret'
end
```

### File conversion

Example to convert file to PDF. All supported formats and options can be found 
[here](https://www.convertapi.com).

```ruby
result = ConvertApi.convert('pdf', File: '/path/to/my_file.docx')

# save to file
result.file.save('/path/to/save/file.pdf')
```

Other result operations:

```ruby
# save all result files to folder
result.save_files('/path/to/save/files')

# get result file io
io = result.file.io

# get conversion cost
conversion_cost = result.conversion_cost 
```

#### Convert file url

```ruby
result = ConvertApi.convert('pdf', File: 'https://website/my_file.docx')
```

#### Specifying from format

```ruby
result = ConvertApi.convert(
  'pdf', 
  { File: /path/to/my_file' }, 
  from_format: 'docx'
)
```

#### Additional conversion parameters

ConvertAPI accepts extra conversion parameters depending on converted formats. All conversion 
parameters and explanations can be found [here](https://www.convertapi.com).

```ruby
result = ConvertApi.convert(
  'pdf', 
  File: /path/to/my_file.docx',
  PageRange: '1-10',
  PdfResolution: '150',
)
```

### User information

You can always check remaining seconds amount by fetching [user information](https://www.convertapi.com/doc/user).

```ruby
user_info = ConvertApi.user

puts user_info['SecondsLeft']
```

### More examples

You can find more advanced examples in the [examples/](examples) folder.


## Development

Run `CONVERT_API_SECRET=your_secret rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ConvertAPI/convertapi-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

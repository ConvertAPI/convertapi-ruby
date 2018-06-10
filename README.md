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

### Convert file

```ruby
result = ConvertApi.convert('pdf', File: /path/to/my_file.docx')

result.save_files('/path/to/save/files')
```

### Convert file url

```ruby
result = ConvertApi.convert('pdf', File: 'https://website/path/to/my_file.docx')

result.save_files('/path/to/save/files')
```

## Development

Run `CONVERT_API_SECRET=your_secret rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ConvertAPI/convertapi-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

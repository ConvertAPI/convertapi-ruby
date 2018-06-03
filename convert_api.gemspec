
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'convert_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'convert_api'
  spec.version       = ConvertApi::VERSION
  spec.authors       = ['Tomas Rutkauskas']
  spec.email         = ['support@convertapi.com']

  spec.summary       = %q{ConvertAPI client library}
  spec.description   = %q{Ruby library for Convert API. Creating PDF and images from various sources like Word, Excel, Powerpoint document, images, web pages or raw HTML codes.}
  spec.homepage      = 'https://github.com/ConvertAPI/convertapi-ruby'
  spec.license       = 'MIT'


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end

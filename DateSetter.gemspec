# -*- encoding: utf-8 -*-
require File.expand_path('../lib/DateSetter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Szymon Rut"]
  gem.email         = ["rut.szymon@gmail.com"]
  gem.description   = %q{It sets a random date in given range}
  gem.homepage      = "https://github.com/RutSzymon/DateSetter"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "DateSetter"
  gem.require_paths = ["lib"]
  gem.version       = DateSetter::VERSION
end

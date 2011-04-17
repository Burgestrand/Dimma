# -*- encoding: utf-8 -*-
require './lib/dimma/version'

Gem::Specification.new do |gem|
  gem.name     = 'dimma'
  gem.summary  = 'A Ruby library for the Beacon REST API'
  gem.homepage = 'http://github.com/Burgestrand/Dimma'
  gem.authors  = ['Kim Burgestrand']
  gem.email    = 'kim@burgestrand.se'
  gem.license  = 'X11 License'
  
  gem.files         = `git ls-files`.split('\n')
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split('\n')
  gem.executables   = []
  gem.require_paths = ['lib']
  
  gem.version     = Dimma::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 1.8.7'
  
  gem.requirements << 'JSON::parse'
  gem.add_dependency 'rest-client'
  gem.add_development_dependency 'bundler', '~> 1.0.0'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'rspec', '~> 2.0'
  gem.add_development_dependency 'yard'
end


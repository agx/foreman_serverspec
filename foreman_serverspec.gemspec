require File.expand_path('../lib/foreman_serverspec/version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'foreman_serverspec'
  s.version     = ForemanServerspec::VERSION
  s.authors     = ['Guido Günther']
  s.email       = ['agx@sigxcpu.org']
  s.homepage    = 'https://github.com/agx/foreman_serverspec'
  s.summary     = 'Store serverspec reports in the Foreman'
  s.description = 'Store results of serverspec runs in the Foreman'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'deface'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end

# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'middleman_dato/version'

Gem::Specification.new do |s|
  s.name = 'middleman-dato'
  s.version = MiddlemanDato::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Stefano Verna']
  s.email = ['s.verna@cantierecreativo.net']
  s.homepage = 'http://cantierecreativo.net'
  s.summary = 'Fetches data from a Dato site'
  s.description = 'Fetches data from a Dato site'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map do |f|
    File.basename(f)
  end
  s.require_paths = ['lib']

  s.add_runtime_dependency('middleman-core', ['>= 3.3.12'])
  s.add_runtime_dependency('faraday', ['>= 0.9.0'])
  s.add_runtime_dependency('faraday_middleware', ['>= 0.9.0'])
  s.add_runtime_dependency('imgix', ['>= 0.3.1'])
  s.add_runtime_dependency('video_embed')
  s.add_runtime_dependency('semantic')
end

# -*- encoding: utf-8 -*-
# frozen_string_literal: true
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

  s.add_development_dependency('coveralls')

  s.add_runtime_dependency 'middleman-core', ['>= 4.1.10']
  s.add_runtime_dependency 'dato', ['>= 0.7.16']
  s.add_runtime_dependency 'activesupport'
  s.add_runtime_dependency 'dotenv', ['<= 2.1']
end

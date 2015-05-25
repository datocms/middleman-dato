# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "middleman-dato"
  s.version     = "0.0.1.rc2"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Stefano Verna"]
  s.email       = ["s.verna@cantierecreativo.net"]
  s.homepage    = "http://cantierecreativo.net"
  s.summary     = %q{Fetches data from a Dato space}
  s.description = %q{Fetches data from a Dato space}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency("middleman-core", [">= 3.3.12"])
  s.add_runtime_dependency("faraday", [">= 0.9.0"])
  s.add_runtime_dependency("faraday_middleware", [">= 0.9.0"])
  s.add_runtime_dependency("imgix", [">= 0.3.1"])
end

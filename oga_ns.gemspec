# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oga_ns/version'

Gem::Specification.new do |spec|
  spec.name          = "oga_ns"
  spec.version       = OgaNs::VERSION
  spec.authors       = ["Jonathan Rochkind"]
  spec.email         = ["jonathan@dnil.net"]
  spec.summary       = %q{An alternate api and semantics for namespaced xpaths in Oga}
  spec.homepage      = "http://github.com/jrochkind/oga_ns"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "oga", "< 1.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end

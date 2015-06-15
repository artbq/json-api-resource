# encoding UTF-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "json_api_resource/version"

Gem::Specification.new do |spec|
  spec.name = "json-api-resource"
  spec.version = JsonApiResource::VERSION
  spec.authors = ["Artem Tseranu"]
  spec.email = ["artbqts@gmail.com"]
  spec.summary = "" # TODO
  spec.description = "" # TODO
  spec.homepage = "" # TODO
  spec.license = "" # TODO

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "typhoeus"
  spec.add_dependency "json"
  spec.add_dependency "activemodel"
  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "geminabox"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "factory_girl"
  spec.add_development_dependency "pry"
end


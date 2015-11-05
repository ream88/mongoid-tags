# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid/tags/version'

Gem::Specification.new do |spec|
  spec.name          = "mongoid-tags"
  spec.version       = Mongoid::Tags::VERSION
  spec.authors       = "Mario Uher"
  spec.email         = "uher.mario@gmail.com"
  spec.homepage      = "https://github.com/haihappen/mongoid-tags"
  spec.summary       = "Simple tagging system with boolean search."
  spec.description   = "Mongoid::Tags adds a simple tagging system to your Mongoid documents, and allows you to query them using a boolean search syntax."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', '~> 4.0'
  spec.add_dependency 'mongoid', '~> 4.0'
  spec.add_dependency 'treetop', '~> 1.5'

  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'yard', '~> 0.8'
end

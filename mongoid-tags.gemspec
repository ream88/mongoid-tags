$: << File.expand_path('../lib', __FILE__)
require 'mongoid/tags/version'

Gem::Specification.new do |gem|
  gem.name          = 'mongoid-tags'
  gem.version       = Mongoid::Tags::VERSION
  gem.authors       = 'Mario Uher'
  gem.email         = 'uher.mario@gmail.com'
  gem.homepage      = 'https://github.com/haihappen/mongoid-tags'
  gem.summary       = 'Simple tagging system with boolean search.'
  gem.description   = 'Mongoid::Tags adds a simple tagging system to your Mongoid documents, and allows you to query them using a boolean search syntax.'

  gem.files         = `git ls-files`.split("\n")
  gem.require_path  = 'lib'

  gem.add_dependency 'activesupport'
  gem.add_dependency 'mongoid'
  gem.add_dependency 'treetop'
end

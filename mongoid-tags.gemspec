require './lib/mongoid/tags/version'

Gem::Specification.new do |gem|
  gem.name          = 'mongoid-tags'
  gem.version       = Mongoid::Tags::VERSION
  gem.authors       = 'Mario Uher'
  gem.email         = 'uher.mario@gmail.com'
  gem.homepage      = 'https://github.com/haihappen/mongoid-tags'
  gem.summary       = 'TODO'
  gem.description   = 'TODO'

  gem.files         = `git ls-files`.split("\n")
  gem.require_path  = 'lib'

  gem.add_dependency 'activesupport'
  gem.add_dependency 'mongoid'
  gem.add_dependency 'treetop'
end

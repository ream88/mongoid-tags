$: << File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'

require 'mongoid/tags'

if defined?(Mongo)
  Mongo::Logger.logger.level = Logger::INFO
end

class Document
  include Mongoid::Document
  include Mongoid::Tags
end

Mongoid.load!(File.expand_path('../mongoid.yml', __FILE__), 'test')
Mongoid.purge!

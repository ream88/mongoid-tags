# frozen_string_literal: true
$LOAD_PATH << File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'

require 'mongoid/tags'

Mongo::Logger.logger.level = Logger::INFO if defined?(Mongo)

class Document
  include Mongoid::Document
  include Mongoid::Tags
end

Mongoid.load!(File.expand_path('../mongoid.yml', __FILE__), 'test')
Mongoid.purge!

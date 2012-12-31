$: << File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'

require 'mongoid/tags'

# Load support *.rb files in ./support
Dir[File.expand_path('../support/*.rb', __FILE__)].each { |file| require_relative file }

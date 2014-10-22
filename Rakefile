#!/usr/bin/env rake
begin
  require 'bundler/setup'
  Bundler.require
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

YARD::Rake::YardocTask.new(:doc)

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'test/*_test.rb'
end

task default: :test

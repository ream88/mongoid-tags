require File.expand_path('../spec_helper', __FILE__)

describe Mongoid::Tags do
  describe :selector do
    let(:query) { @__name__.match(/test_\d+_(.*)/).to_a.last } # Use description as query ;)
    subject { Document.selector(query) }


    it 'foo' do
      subject.must_equal '$in' => %w[foo]
    end


    it '+foo' do
      subject.must_equal '$all' => %w[foo]
    end


    it '- foo' do
      proc { subject }.must_raise Mongoid::Tags::Error
    end


    it '-foo' do
      subject.must_equal '$nin' => %w[foo]
    end


    it '- foo' do
      proc { subject }.must_raise Mongoid::Tags::Error
    end


    it '/foo' do
      proc { subject }.must_raise Mongoid::Tags::Error
    end


    it 'foo bar' do
      subject.must_equal '$in' => %w[foo bar]
    end


    it 'foo +bar' do
      subject.must_equal '$in' => %w[foo], '$all' => %w[bar]
    end


    it 'foo + bar' do
      proc { subject }.must_raise Mongoid::Tags::Error
    end


    it 'foo +bar +baz' do
      subject.must_equal '$in' => %w[foo], '$all' => %w[bar baz]
    end


    it 'foo +bar baz' do
      subject.must_equal '$in' => %w[foo baz], '$all' => %w[bar]
    end


    it 'foo +bar -baz' do
      subject.must_equal '$in' => %w[foo], '$all' => %w[bar], '$nin' => %w[baz]
    end


    it 'foo foo foo' do
      # Removing duplicates does not gain any
      # performance improvements.
      skip
      subject.must_equal '$in' => %w[foo]
    end
  end
end

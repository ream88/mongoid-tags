require_relative 'spec_helper'

describe 'Mongoid::Tags integration' do
  before do
    # Create all possible combinations
    3.times do |i|
      %w[foo bar baz].combination(i + 1).each do |tags|
        Document.create(tags: tags)
      end
    end
  end


  let(:query) { self.class.name.demodulize } # Use description as query ;)
  subject { Document.tagged(query) }


  describe 'foo' do
    it 'returns documents including foo' do
      subject.all? { |d| d.tags.include?('foo') }.must_equal true
    end
  end


  describe '+foo' do
    it 'returns documents including at least foo' do
      subject.all? { |d| d.tags.include?('foo') }.must_equal true
    end
  end


  describe '-foo' do
    it 'returns documents not including foo' do
      subject.none? { |d| d.tags.include?('foo') }.must_equal true
    end
  end


  describe 'foo bar' do
    it 'returns documents including foo or bar' do
      subject.all? { |d| d.tags.include?('foo') || d.tags.include?('bar') }.must_equal true
    end
  end


  describe '+foo bar' do
    it 'returns documents including foo and bar' do
      subject.all? { |d| d.tags.include?('foo') }.must_equal true
      subject.all? { |d| d.tags.include?('bar') }.must_equal true
    end
  end


  describe '-foo bar' do
    it 'returns documents not including foo, but bar' do
      subject.none? { |d| d.tags.include?('foo') }.must_equal true
      subject.all?  { |d| d.tags.include?('bar') }.must_equal true
    end
  end


  describe '-foo -bar' do
    it 'returns documents not including foo and bar' do
      subject.none? { |d| d.tags.include?('foo') }.must_equal true
      subject.none? { |d| d.tags.include?('bar') }.must_equal true
    end
  end


  describe 'foo bar baz' do
    it 'returns documents including foo or bar' do
      subject.all? { |d| d.tags.include?('foo') || d.tags.include?('bar') || d.tags.include?('baz') }.must_equal true
    end
  end


  describe '+foo bar baz' do
    it 'returns documents including at least foo and bar or baz' do
      subject.all? { |d| d.tags.include?('foo') }.must_equal true
      subject.all? { |d| d.tags.include?('bar') || d.tags.include?('baz') }.must_equal true
    end
  end


  describe '+foo +bar baz' do
    it 'returns documents including at least foo, bar and baz' do
      subject.all? { |d| d.tags.include?('foo') }.must_equal true
      subject.all? { |d| d.tags.include?('bar') }.must_equal true
      subject.all? { |d| d.tags.include?('baz') }.must_equal true
    end
  end


  describe '-foo bar baz' do
    it 'returns documents not including foo, but bar or baz' do
      subject.none? { |d| d.tags.include?('foo') }.must_equal true
      subject.all?  { |d| d.tags.include?('bar') || d.tags.include?('baz') }.must_equal true
    end
  end


  describe '-foo -bar baz' do
    it 'returns documents not including foo and bar, but baz' do
      subject.none? { |d| d.tags.include?('foo') }.must_equal true
      subject.none? { |d| d.tags.include?('bar') }.must_equal true
      subject.all?  { |d| d.tags.include?('baz') }.must_equal true
    end
  end


  describe '-foo -bar -baz' do
    it 'returns documents not including foo, bar and baz' do
      subject.none? { |d| d.tags.include?('foo') }.must_equal true
      subject.none? { |d| d.tags.include?('bar') }.must_equal true
      subject.none? { |d| d.tags.include?('baz') }.must_equal true
    end
  end


  after { Document.destroy_all }
end

require_relative 'test_helper'

# Create all possible combinations of tags.
3.times do |i|
  %w[foo bar baz].combination(i + 1).each do |tags|
    Document.create tags: tags
  end
end

# Litte helper which helps to DRY tests.
def include?(*tags)
  proc do |document|
    tags.any? do |tag|
      document.tags.include?(tag)
    end
  end
end


class IntegrationTest < Minitest::Unit::TestCase
  def test_documents_including_foo
    assert Document.tagged('foo').all? &include?('foo')
  end


  def test_documents_including_at_least_foo
    assert Document.tagged('+foo').all? &include?('foo')
  end


  def test_documents_not_including_foo
    assert Document.tagged('-foo').none? &include?('foo')
  end


  def test_documents_including_foo_or_bar
    assert Document.tagged('foo bar').all? &include?('foo', 'bar')
  end


  def test_documents_including_foo_and_bar
    documents = Document.tagged('+foo bar')

    assert documents.all? &include?('foo')
    assert documents.all? &include?('bar')
  end


  def test_documents_not_including_foo_but_bar
    documents = Document.tagged('-foo bar')

    assert documents.none? &include?('foo')
    assert documents.all?  &include?('bar')
  end


  def test_documents_not_including_foo_and_bar
    documents = Document.tagged('-foo -bar')

    assert documents.none? &include?('foo')
    assert documents.none? &include?('bar')
  end


  def test_documents_including_foo_or_bar_or_baz
    assert Document.tagged('foo bar baz').all? &include?('foo', 'bar', 'baz')
  end


  def test_documents_including_at_foo_and_maybe_bar_or_baz
    documents = Document.tagged('+foo bar baz')

    assert documents.all? &include?('foo')
    assert documents.all? &include?('bar', 'baz')
  end


  def test_documents_including_at_least_foo_and_bar_maybe_baz
    documents = Document.tagged('+foo +bar baz')

    assert documents.all? &include?('foo')
    assert documents.all? &include?('bar')
    assert documents.all? &include?('baz')
  end


  def test_documents_not_including_foo_but_bar_or_baz
    documents = Document.tagged('-foo bar baz')

    assert documents.none? &include?('foo')
    assert documents.all?  &include?('bar', 'baz')
  end


  def test_documents_not_including_foo_but_bar_and_maybe_baz
    documents = Document.tagged('-foo +bar baz')

    assert documents.none? &include?('foo')
    assert documents.all?  &include?('bar')
    assert documents.any?  &include?('baz')
  end


  def test_documents_not_including_foo_and_bar_but_baz
    documents = Document.tagged('-foo -bar baz')

    assert documents.none? &include?('foo')
    assert documents.none? &include?('bar')
    assert documents.all?  &include?('baz')
  end


  def test_documents_not_including_foo_and_bar_and_baz
    documents = Document.tagged('-foo -bar -baz')

    assert documents.none? &include?('foo')
    assert documents.none? &include?('bar')
    assert documents.none? &include?('baz')
  end
end

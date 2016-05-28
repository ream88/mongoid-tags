# frozen_string_literal: true
require_relative 'test_helper'

# Create all possible combinations of tags.
4.times do |i|
  %w(foo bar baz qux).combination(i + 1).each do |tags|
    Document.create tags: tags
  end
end

# Little helper which helps to DRY tests.
def include?(*tags)
  proc do |document|
    tags.any? do |tag|
      document.tags.include?(tag)
    end
  end
end

def include_all?(*tags)
  proc do |document|
    tags.all? do |tag|
      document.tags.include?(tag)
    end
  end
end

class IntegrationTest < Minitest::Test
  def test_documents_including_foo
    assert Document.tagged('foo').all?(&include?('foo'))
  end

  def test_documents_including_at_least_foo
    assert Document.tagged('+foo').all?(&include?('foo'))
  end

  def test_documents_not_including_foo
    assert Document.tagged('-foo').none?(&include?('foo'))
  end

  def test_documents_including_foo_or_bar
    assert Document.tagged('foo bar').all?(&include?('foo', 'bar'))
  end

  def test_documents_including_foo_and_bar
    documents = Document.tagged('+foo bar')

    assert documents.all?(&include?('foo'))
    assert documents.all?(&include?('bar'))
  end

  def test_documents_not_including_foo_but_bar
    documents = Document.tagged('-foo bar')

    assert documents.none?(&include?('foo'))
    assert documents.all?(&include?('bar'))
  end

  def test_documents_not_including_foo_and_bar
    documents = Document.tagged('-foo -bar')

    assert documents.none?(&include?('foo'))
    assert documents.none?(&include?('bar'))
  end

  def test_documents_including_foo_or_bar_or_baz
    assert Document.tagged('foo bar baz').all?(&include?('foo', 'bar', 'baz'))
  end

  def test_documents_including_at_foo_and_maybe_bar_or_baz
    documents = Document.tagged('+foo bar baz')

    assert documents.all?(&include?('foo'))
    assert documents.all?(&include?('bar', 'baz'))
  end

  def test_documents_including_at_least_foo_and_bar_maybe_baz
    documents = Document.tagged('+foo +bar baz')

    assert documents.all?(&include?('foo'))
    assert documents.all?(&include?('bar'))
    assert documents.all?(&include?('baz'))
  end

  def test_documents_not_including_foo_but_bar_or_baz
    documents = Document.tagged('-foo bar baz')

    assert documents.none?(&include?('foo'))
    assert documents.all?(&include?('bar', 'baz'))
  end

  def test_documents_not_including_foo_but_bar_and_maybe_baz
    documents = Document.tagged('-foo +bar baz')

    assert documents.none?(&include?('foo'))
    assert documents.all?(&include?('bar'))
    assert documents.any?(&include?('baz'))
  end

  def test_documents_not_including_foo_and_bar_but_baz
    documents = Document.tagged('-foo -bar baz')

    assert documents.none?(&include?('foo'))
    assert documents.none?(&include?('bar'))
    assert documents.all?(&include?('baz'))
  end

  def test_documents_not_including_foo_and_bar_and_baz
    documents = Document.tagged('-foo -bar -baz')

    assert documents.none?(&include?('foo'))
    assert documents.none?(&include?('bar'))
    assert documents.none?(&include?('baz'))
  end

  def test_documents_including_both_foo_and_bar_and_or_baz
    documents = Document.tagged('(+foo +bar) baz').to_a

    assert documents.any?(&include_all?('foo', 'bar'))
    documents.delete_if(&include_all?('foo', 'bar'))

    assert documents.all?(&include?('baz'))
  end

  def test_documents_including_both_foo_and_bar_and_or_baz_or_qux
    documents = Document.tagged('(+foo +bar) baz qux').to_a

    assert documents.any?(&include_all?('foo', 'bar'))
    documents.delete_if(&include_all?('foo', 'bar'))

    assert documents.any?(&include?('baz', 'qux'))
  end

  def test_documents_including_foo_and_bar_or_baz_and_qux
    documents = Document.tagged('(+foo +bar)(+baz +qux)').to_a

    assert documents.any?(&include_all?('foo', 'bar'))
    documents.delete_if(&include_all?('foo', 'bar'))

    assert documents.any?(&include_all?('baz', 'qux'))
  end
end

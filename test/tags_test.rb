require_relative 'test_helper'

class TagsTest < Minitest::Unit::TestCase
  def assert_selector(query, selector)
    assert_equal selector, Document.selector(query)
  end

  def test_valid_queries
    assert_selector 'foo', '$in' => %w[foo]
    assert_selector '+foo', '$all' => %w[foo]
    assert_selector '-foo', '$nin' => %w[foo]
    assert_selector 'foo bar', '$in' => %w[foo bar]
    assert_selector 'foo +bar', '$in' => %w[foo], '$all' => %w[bar]
    assert_selector 'foo +bar +baz', '$in' => %w[foo], '$all' => %w[bar baz]
    assert_selector 'foo +bar baz', '$in' => %w[foo baz], '$all' => %w[bar]
    assert_selector 'foo +bar -baz', '$in' => %w[foo], '$all' => %w[bar], '$nin' => %w[baz]
  end

  def test_invalid_queries
    assert_raises Mongoid::Tags::Error do
      Document.selector('+ foo')
    end

    assert_raises Mongoid::Tags::Error do
      Document.selector('- foo')
    end

    assert_raises Mongoid::Tags::Error do
      Document.selector('/ foo')
    end

    assert_raises Mongoid::Tags::Error do
      Document.selector('foo + bar')
    end
  end
end

require_relative 'test_helper'

class TagsTest < Minitest::Test
  def assert_selector(query, selector)
    assert_equal selector, Document.selector(query)
  end

  def test_valid_queries
    assert_selector 'foo', { 'tags' => { '$in' => %w[foo] }}
    assert_selector '+foo', { 'tags' => { '$all' => %w[foo] }}
    assert_selector '-foo', { 'tags' => { '$nin' => %w[foo] }}
    assert_selector 'foo bar', { 'tags' => { '$in' => %w[foo bar] }}
    assert_selector 'foo +bar', { 'tags' => { '$in' => %w[foo], '$all' => %w[bar] }}
    assert_selector 'foo +bar +baz', { 'tags' => { '$in' => %w[foo], '$all' => %w[bar baz] }}
    assert_selector 'foo +bar baz', { 'tags' => { '$in' => %w[foo baz], '$all' => %w[bar] }}
    assert_selector 'foo +bar -baz', { 'tags' => { '$in' => %w[foo], '$all' => %w[bar], '$nin' => %w[baz] }}

    assert_selector '(foo)', { '$or' => [{ 'tags' => { '$in' => %w[foo] } }] }
    assert_selector '(foo bar)', { '$or' => [{ 'tags' => { '$in' => %w[foo bar] } }] }
    assert_selector '( foo bar )', { '$or' => [{ 'tags' => { '$in' => %w[foo bar] } }] }
    assert_selector '(foo)(bar)', { '$or' => [{ 'tags' => { '$in' => %w[foo] } }, { 'tags' => { '$in' => %w[bar] } }] }
    assert_selector '(foo)(bar)(baz)', { '$or' => [{ 'tags' => { '$in' => %w[foo] } }, { 'tags' => { '$in' => %w[bar] } }, { 'tags' => { '$in' => %w[baz] } }] }
    assert_selector '(+foo)(-bar)', { '$or' => [{ 'tags' => { '$all' => %w[foo] } }, { 'tags' => { '$nin' => %w[bar] } }] }

    assert_selector '(+foo +bar)(+foo +baz)', { '$or' => [{ 'tags' => { '$all' => %w[foo bar] } }, { 'tags' => { '$all' => %w[foo baz] } }] }
    assert_selector '(+foo +bar)(+foo +baz)(+foo +qux)', { '$or' => [{ 'tags' => { '$all' => %w[foo bar] } }, { 'tags' => { '$all' => %w[foo baz] } }, { 'tags' => { '$all' => %w[foo qux] } }] }

    assert_selector '(+foo +bar) baz qux', { '$or' => [{ 'tags' => { '$all' => %w[foo bar] } }, { 'tags' => { '$in' => %w[baz qux] } } ]}

    assert_selector '_foo _bar', { 'tags' => { '$in' => %w[_foo _bar] }}
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

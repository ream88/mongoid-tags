# mongoid-tags [![Build Status](https://travis-ci.org/haihappen/mongoid-tags.svg?branch=master)](https://travis-ci.org/haihappen/mongoid-tags)

Mongoid::Tags adds a simple tagging system to your Mongoid documents,
and allows you to query them using a boolean search syntax.


## Installation

In your Gemfile:

```ruby
gem 'mongoid-tags'
```


## Usage

```ruby
class Document
  include Mongoid::Document
  include Mongoid::Tags
end

# Documents tagged foo || bar
Document.tagged('foo bar')

# Documents tagged foo && bar
Document.tagged('+foo bar')

# Documents tagged foo, but !bar
Document.tagged('foo -bar')

# Documents tagged foo and bar or baz
Document.tagged('(+foo +bar) baz')

# Documents tagged foo and bar, or foo and baz
Document.tagged('(+foo +bar)(+foo +baz)')

# Chaining calls
Document.where(published: true).tagged('foo').desc(:created_at)
```

Be sure to checkout [test/integration_test.rb](test/integration_test.rb) for more examples.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Copyright

(The MIT license)

Copyright (c) 2012-2015 Mario Uher

See LICENSE.md.

# mongoid-tags

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
```

```ruby
# Documents tagged foo || bar
Document.tagged('foo bar')

# Documents tagged foo && bar
Document.tagged('+foo bar')

# Documents tagged foo, but !bar
Document.tagged('foo -bar')
```

Be sure to checkout spec/integration_spec.rb for more examples. By the way, `tagged` returns a `Mongoid::Criteria` object so you can chain it to your existing criteria, e.g: `Document.where(published: true).tagged('foo').desc(:created_at)`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

(The MIT license)

Copyright (c) 2012 Mario Uher

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

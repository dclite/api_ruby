# DCLiteRb

[![Gem Version](https://badge.fury.io/rb/dcliterb.svg)](http://badge.fury.io/rb/dcliterb)

This gem provides you with simple Ruby interface for api.dclite.ru mail service.

Documentation available at https://www.rubydoc.info/gems/dcliterb/

Original API documentation https://dclite.ru/api/

At this moment, mainly list management features implemented, but there are common way to call any API method, using *#call_method*

## Installation

Add this line to your application's Gemfile:

    gem 'dcliterb'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dcliterb

## Usage

DCLiteRb declares some classes for API objects, like *List*, *Member*, etc

    require "dcliterb"
    conn = DCLite::Connection.new('login', 'password')
    conn.lists # => Array of DCLite::List instances

Optionally you can additionally pass third parameter to DCLite::Connection constructor, to change API url (for example if you plan to use compatible service):

    conn = DCLite::Connection.new('login', 'password', 'https://api.dclite.ru')

Also, you can use universal invocation method with *#call_method*

    conn.call_method('lists.get_members', list_id: 1)

## Contributing
1. Fork it ( https://github.com/dclite/api_ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

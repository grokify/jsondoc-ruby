JsonDoc
=======

[![Gem Version][gem-version-svg]][gem-version-link]
[![Build Status][build-status-svg]][build-status-link]
[![Coverage Status][coverage-status-svg]][coverage-status-link]
[![Dependency Status][dependency-status-svg]][dependency-status-link]
[![Code Climate][codeclimate-status-svg]][codeclimate-status-link]
[![Scrutinizer Code Quality][scrutinizer-status-svg]][scrutinizer-status-link]
[![Docs][docs-rubydoc-svg]][docs-rubydoc-link]
[![License][license-svg]][license-link]

Generic JSON document base class to set/get document attributes based on JSON Schema, dump as JSON and support building of CSV and Excel workbooks. Subclasses can be built with additional functionality, e.g. using the `setAttr` method. Primary use cases include being used with parsers to create JSON documents and to create CSV/Excel reports.

## Installation

### Via Bundler

Add `jsondoc` to `Gemfile` and then run `bundle`:

```sh
$ echo "gem 'jsondoc'" >> Gemfile
$ bundle
```

### Via RubyGems

```sh
$ gem install jsondoc
```

## Usage

```ruby
require 'jsondoc'

my_data = {}

my_schema = {
  type: 'My Document Type',
  properties: {
    first_name:      {type: 'string', description: 'First Name', default: ''},
    last_name:       {type: 'string', description: 'Last Name',  default: ''},
    email_addresses: {type: 'array' , description: 'Email Addresses', default: []}
  }
}

thisUser = JsonDoc::Document.new(my_data, my_schema)
thisUser.setAttr(:first_name, 'John')
thisUser.setAttr(:last_name,  'Doe')

first_name = thisUser.getAttr(:first_name)

thisUserHash = thisUser.asHash
thisUserJson = thisUser.asJson

descs  = thisUser.getDescArrayForProperties( [:first_name,:last_name] )
values = thisUser.getValArrayForProperties(  [:first_name,:last_name] )

thisUser.pushAttr(:email_addresses, 'john@example.com')
thisUser.pushAttr(:email_addresses, 'john.doe@example.com')

thisUser.cpAttr(:first_name, :last_name)
```

## Notes

### Schema Validation

Schema validation is not provided in this version.

## Links

1. JSON
  * http://www.json.org/
2. JSON Schema
  * http://json-schema.org/

## License

JsonDoc is available under an MIT-style license. See [LICENSE.txt](LICENSE.txt) for details.

JsonDoc &copy; 2014-2023 by John Wang

 [gem-version-svg]: https://badge.fury.io/rb/jsondoc.svg
 [gem-version-link]: http://badge.fury.io/rb/jsondoc
 [build-status-svg]: https://api.travis-ci.org/grokify/jsondoc-ruby.svg?branch=master
 [build-status-link]: https://travis-ci.org/grokify/jsondoc-ruby
 [coverage-status-svg]: https://coveralls.io/repos/grokify/jsondoc-ruby/badge.svg?branch=master
 [coverage-status-link]: https://coveralls.io/r/grokify/jsondoc-ruby?branch=master
 [dependency-status-svg]: https://gemnasium.com/grokify/jsondoc-ruby.svg
 [dependency-status-link]: https://gemnasium.com/grokify/jsondoc-ruby
 [codeclimate-status-svg]: https://codeclimate.com/github/grokify/jsondoc-ruby/badges/gpa.svg
 [codeclimate-status-link]: https://codeclimate.com/github/grokify/jsondoc-ruby
 [scrutinizer-status-svg]: https://scrutinizer-ci.com/g/grokify/jsondoc-ruby/badges/quality-score.png?b=master
 [scrutinizer-status-link]: https://scrutinizer-ci.com/g/grokify/jsondoc-ruby/?branch=master
 [downloads-svg]: http://ruby-gem-downloads-badge.herokuapp.com/jsondoc
 [downloads-link]: https://rubygems.org/gems/jsondoc
 [docs-rubydoc-svg]: https://img.shields.io/badge/docs-rubydoc-blue.svg
 [docs-rubydoc-link]: http://www.rubydoc.info/gems/jsondoc/
 [license-svg]: https://img.shields.io/badge/license-MIT-blue.svg
 [license-link]: https://github.com/grokify/jsondoc-ruby/blob/master/LICENSE.txt

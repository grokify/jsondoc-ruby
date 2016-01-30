JsonDoc
=======

[![Gem Version][gem-version-svg]][gem-version-link]
[![Dependency Status][dependency-status-svg]][dependency-status-link]
[![Scrutinizer Code Quality][scrutinizer-status-svg]][scrutinizer-status-link]
[![Downloads][downloads-svg]][downloads-link]
[![Docs][docs-rubydoc-svg]][docs-rubydoc-link]
[![License][license-svg]][license-link]

Generic JSON document base class to set/get document attributes based on JSON Schema, dump as JSON and support building of CSV and Excel workbooks. Subclasses can be built with additional functionality, e.g. using the setAttr method. Primary use cases include being used with parsers to create JSON documents and to create CSV/Excel reports.

## Installation

### Gem Installation

Download and install jsondoc with the following:

```sh
$ gem install jsondoc
```

## Usage

```ruby
require 'jsondoc'

mySchema      =  {
  :type       => 'My Document Type',
  :properties => {
    :first_name      => { :type => 'string', :description => 'First Name', :default => '' },
    :last_name       => { :type => 'string', :description => 'Last Name',  :default => '' },
    :email_addresses => { :type => 'array' , :description => 'Email Addresses', :default => [] }
  }
}

thisUser = JsonDoc::Document.new( mySchema )
thisUser.setAttr( :first_name, 'John' )
thisUser.setAttr( :last_name,  'Doe'  )

first_name = thisUser.getAttr( :first_name )

thisUserHash = thisUser.asHash
thisUserJson = thisUser.asJson

descs  = thisUser.getDescArrayForProperties( [:first_name,:last_name] )
values = thisUser.getValArrayForProperties(  [:first_name,:last_name] )

thisUser.pushAttr( :email_addresses, 'john@example.com' )
thisUser.pushAttr( :email_addresses, 'john.doe@example.com' )

thisUser.cpAttr( :first_name, :last_name )
```

## Notes

### Schema Validation

Schema validation is not provided in this version.

## Links

1. JSON
  * http://www.json.org/
2. JSON Schema
  * http://json-schema.org/

### Problems, Comments, Suggestions?

All of the above are most welcome. mailto:johncwang@gmail.com

## Credits

John Wang - http://johnwang.com

## License

JsonDoc is available under an MIT-style license.

:include: MIT-LICENSE 

## Warranty

This software is provided "as is" and without any express or implied warranties, including, without limitation, the implied warranties of merchantibility and fitness for a particular purpose.

 [gem-version-svg]: https://badge.fury.io/rb/jsondoc.svg
 [gem-version-link]: http://badge.fury.io/rb/jsondoc
 [downloads-svg]: http://ruby-gem-downloads-badge.herokuapp.com/jsondoc
 [downloads-link]: https://rubygems.org/gems/jsondoc
 [dependency-status-svg]: https://gemnasium.com/grokify/jsondoc-ruby.svg
 [dependency-status-link]: https://gemnasium.com/grokify/jsondoc-ruby
 [scrutinizer-status-svg]: https://scrutinizer-ci.com/g/grokify/jsondoc-ruby/badges/quality-score.png?b=master
 [scrutinizer-status-link]: https://scrutinizer-ci.com/g/grokify/jsondoc-ruby/?branch=master
 [docs-rubydoc-svg]: https://img.shields.io/badge/docs-rubydoc-blue.svg
 [docs-rubydoc-link]: http://www.rubydoc.info/gems/jsondoc/
 [license-svg]: https://img.shields.io/badge/license-MIT-blue.svg
 [license-link]: https://github.com/grokify/jsondoc-ruby/blob/master/LICENSE.txt


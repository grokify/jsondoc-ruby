= JsonDoc

Generic JSON document base class to set/get document attributes based on JSON Schema, dump as JSON and support building of CSV and Excel workbooks. Subclasses can be built with additional functionality, e.g. using the setAttr method. Primary use cases include being used with parsers to create JSON documents and to create CSV/Excel reports.

== Installation

=== Gem Installation

Download and install jsondoc with the following:

  gem install jsondoc

== Usage

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

== Notes

=== Schema Validation

Schema validation is not provided in this version.

== Links

JSON

http://www.json.org/

JSON Schema

http://json-schema.org/

== Problems, Comments, Suggestions?

All of the above are most welcome. mailto:johncwang@gmail.com

== Credits

John Wang - http://johnwang.com

== License

JsonDoc is available under an MIT-style license.

:include: MIT-LICENSE 

== Warranty

This software is provided "as is" and without any express or implied warranties, including, without limitation, the implied warranties of merchantibility and fitness for a particular purpose.

require 'coveralls'
Coveralls.wear!

require 'test/unit'
require 'mocha/test_unit'
require 'jsondoc'

doc = JsonDoc::Document.new({},{},true,true)

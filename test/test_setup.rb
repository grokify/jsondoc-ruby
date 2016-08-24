require './test/test_base.rb'

class JsonDocTest < Test::Unit::TestCase
  def testSetup

    schemaTest =  {
      type: 'TestDocument',
      properties: {
        id: { default: 'abc',   type: 'string', description: 'Id'    },
        foo: { default: 'bar',   type: 'string', description: 'Foo'   },
        hello: { default: 'world', type: 'string', description: 'Hello' },
        array: { default: ['foo'], type: 'array',  description: 'Array' }
      }
    }

    jDoc = JsonDoc::Document.new({},schemaTest,true,true)

    assert_equal 'abc'          , jDoc.getAttr(:id)
    assert_equal "abc\tbar"     , jDoc.getValStringForProperties([:id,:foo])
    assert_equal ['bar','world'], jDoc.getValArrayForProperties([:foo,:hello])
    assert_equal "Id\tFoo"      , jDoc.getDescStringForProperties([:id,:foo])
    assert_equal ['Foo','Hello'], jDoc.getDescArrayForProperties([:foo,:hello])

    jDoc.setAttr(:foo,'baz')
    assert_equal 'baz'          , jDoc.getAttr(:foo)
    assert_equal "abc\tbaz"     , jDoc.getValStringForProperties([:id,:foo])
    assert_equal ['abc','baz']  , jDoc.getValArrayForProperties([:id,:foo])

    assert_equal ['foo'], jDoc.getAttr(:array)
    jDoc.pushAttr(:array,'bar')
    assert_equal ['foo','bar'], jDoc.getAttr(:array)
    jDoc.pushAttr(:array,'baz')
    assert_equal ['foo','bar','baz'], jDoc.getAttr(:array)
    jDoc.setAttr(:array,['qux'])
    assert_equal ['qux'], jDoc.getAttr(:array)

    jDoc.setAttr(:id ,'abc')
    jDoc.setAttr(:foo,'bar')
    jDoc.cpAttr(:id,:foo)
    assert_equal jDoc.getAttr(:id), jDoc.getAttr(:foo)

  end

  def testNested()
    data = {
      foo: {
        bar: { baz: 10 }
      }
    }
    doc = JsonDoc::Document.new(data,{},false,false)
    assert_equal 10, doc.getAttr('foo.bar.baz')
  end

  def testNotNested()
    doc2 = JsonDoc::Document.new({},{},false,false)
    doc2.bUseDeepKeys = false
    doc2.setAttr('foo.bar.baz', 'deadbeef')

    assert_equal 'deadbeef', doc2.dDocument[:'foo.bar.baz']
  end
end

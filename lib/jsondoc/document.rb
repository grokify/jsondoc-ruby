require 'json'

class Symbol
  def split(separator)
    to_s.split(separator).map(&:to_sym)
  end
end

module JsonDoc
  class Document
    attr_reader :dDocument

    attr_accessor :bIsStrict
    attr_accessor :bUseKeyAsDesc
    attr_accessor :bUseDeepKeys

    def initialize(dValues=nil,dSchema=nil,bDefaultifyDoc=false,bIsStrict=true,opts={})
      @dSchema        = dSchema || self.getDefaultSchema()
      @bDefaultifyDoc = bDefaultifyDoc ? true : false
      @bIsStrict      = bIsStrict ? true : false
      @bUseKeyAsDesc  = false
      @bUseDeepKeys   = opts.key?(:bUseDeepKeys) ? opts[:bUseDeepKeys] : true
      @dDocument      = self.getDefaultDocument()
      self.loadHash(dValues) if dValues.is_a?(Hash)
    end

    def getDefaultSchema
      {
        type: '',
        properties: {
          id: {default: '', description: 'Doc Id', type: 'string'}
        }
      }
    end

    def getDefaultDocument
      dDocument = {}
      if @bDefaultifyDoc && @dSchema.key?(:properties)
        @dSchema[:properties].keys.each do |yKey|
          dProperty = @dSchema[:properties][yKey]
          xxVal = dProperty.key?(:default) ? dProperty[:default] : ''
          dDocument[yKey] = xxVal
        end
      end
      dDocument
    end

    def loadHash(dValues = nil)
      if dValues.nil?
        return
      elsif ! dValues.is_a?(Hash)
        raise ArgumentError, 'E_INITIAL_VALUES_IS_NOT_A_HASH'
      end
      dValues.each do |yKey,xxVal|
        self.setProp(yKey,xxVal)
      end
      self
    end

    def getProp(yKey = nil)
      raise ArgumentError, 'E_BAD_KEY__IS_NIL' if yKey.nil?

      yKey = yKey.to_sym if yKey.is_a?(String)

      if @bUseDeepKeys
        aKeys = yKey.split('.') # = yKey.to_s.split('.').map(&:to_sym)

        dDoc  = @dDocument
        xxVal = getPropRecurse(aKeys.clone,dDoc)
        return xxVal
      end
      return @dDocument.key?(yKey) ? @dDocument[yKey] : nil
    end

    def getPropRecurse(aKeys = [], dDoc = nil)
      yKey = aKeys.shift
      if ! yKey.is_a?(Symbol) || yKey.length<1 || ! dDoc.key?( yKey )
        return nil
      end
      xxVal = dDoc[ yKey ]
      if aKeys.length == 0
        return xxVal
      elsif dDoc.is_a?(Hash)
        return getPropRecurse( aKeys, xxVal )
      else
        raise ArgumentError, "E_BAD_VAL__IS_NOT_HASH"
      end
    end

    def getPropSingle(yKey = nil)
      raise ArgumentError, 'E_BAD_KEY__IS_NIL' if yKey.nil?
      yKey = yKey.to_sym if yKey.is_a?(String)
      xxVal = @dDocument.key?(yKey) ? @dDocument[yKey] : nil
      if xxVal.nil? && @bIsStrict
        self.validateKey(yKey)
      end
      xxVal
    end

    def validateKey(yKey = nil)
      raise ArgumentError, "E_BAD_KEY__IS_NIL [#{yKey.to_s}]" if yKey.nil?

      return true unless @bIsStrict

      bKeyExists = @dSchema.key?(:properties) \
        && @dSchema[:properties].key?(yKey) ? true : false

      raise ArgumentError, "E_UNKNOWN_KEY__STRICT #{yKey.to_s}" unless bKeyExists

      return true
    end

    def setProp(yKey = nil, xxVal = nil)
      yKey = yKey.to_sym if yKey.is_a?(String)

      self.validateKey(yKey)

      @dDocument[yKey] = xxVal
    end

    def pushProp(yKey = nil, xxVal = nil)
      yKey = yKey.to_sym if yKey.is_a?(String)
      self.validateKey(yKey)

      if @dDocument.key?(yKey)
        if @dDocument[yKey].is_a?(Array)
          @dDocument[yKey].push xxVal
        else
          raise RuntimeError, 'E_PROPERTY_IS_NOT_ARRAY'
        end
      else
        @dDocument[yKey] = [xxVal]
      end
    end

    def cpProp(yKeySrc = nil, yKeyDest = nil)
      yKeySrc = yKeySrc.to_sym if yKeySrc.is_a?(String)
      yKeyDest = yKeyDest.to_sym if yKeyDest.is_a?(String)
      self.setAttr(yKeyDest, self.getAttr(yKeySrc))
    end

    def sortKeys
      @dDocument.keys.sort!
    end

    def fromJson(jDocument = nil)
      if jDocument.is_a?(String)
        @dDocument = JSON.load(jDocument)
      end
      return self
    end

    def fromDict(dDocument = nil)
      @dDocument = dDocument if dDocument.is_a?(Hash)
    end

    def asHash
      @dDocument
    end

    def asJson
      JSON.dump( self.asHash() )
    end

    def getValStringForProperties(aCols = nil, sDelimiter = "\t")
      sDelimiter = "\t" unless sDelimiter.is_a?(String) && sDelimiter.length>0
      aVals = self.getValArrayForProperties(aCols)
      sVals = aVals.join(sDelimiter)
    end

    def getValArrayForProperties(aCols = nil, xxNil = '')
      aVals = []
      return aVals if aCols.nil?

      if @bUseKeyAsDesc
        asVals = aCols.map {|x| x.to_s }
      end

      aCols.each do |yKey|
        yKey  = yKey.to_sym if yKey.is_a?(String)
        xxVal = getProp( yKey )
        #xVal = @dDocument.key?(yKey) ? @dDocument[yKey] : nil
        xxVal = xxNil if xxVal.nil?
        aVals.push xxVal
      end
      aVals
    end

    def getDescStringForProperties(aCols = nil,sDelimiter = "\t")
      sDelimiter = "\t" unless sDelimiter.is_a?(String) && sDelimiter.length>0
      aVals = self.getDescArrayForProperties(aCols)
      aVals.join(sDelimiter)
    end

    def getDescArrayForProperties(aCols = nil)
      aVals = []
      return aVals if aCols.nil?
      aCols.each do |yKey|
        yKey = yKey.to_sym if yKey.is_a?(String)
        xxVal = (
          @dSchema.key?(:properties)                          \
          && @dSchema[:properties].key?(yKey)                 \
          && @dSchema[:properties][yKey].key?(:description)   \
          && @dSchema[:properties][yKey][:description].length > 0
        ) \
          ? @dSchema[:properties][yKey][:description] : yKey.to_s

        xxVal = xxVal.to_s unless xxVal.is_a?(String)

        aVals.push xxVal
      end
      aVals
    end

    alias_method :setAttr , :setProp
    alias_method :getAttr , :getProp
    alias_method :pushAttr, :pushProp
    alias_method :cpAttr  , :cpProp
  end
end

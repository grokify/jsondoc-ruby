require 'json'

class Symbol
  def split(separator)
    to_s.split(separator).map(&:to_sym)
  end
end

module JsonDoc
  class Document
    attr_accessor :bIsStrict
    attr_accessor :bUseKeyAsDesc

    def initialize(dValues=nil,dSchema=nil,bDefaultifyDoc=false,bIsStrict=true)
      @dSchema        = dSchema || self.getDefaultSchema()
      @bDefaultifyDoc = bDefaultifyDoc ? true : false
      @bIsStrict      = bIsStrict      ? true : false
      @bUseKeyAsDesc  = false
      @dDocument      = self.getDefaultDocument()
      self.loadHash(dValues) if dValues.is_a?(Hash)
    end

    def getDefaultSchema()
      dSchema       =  {
        :type       => '',
        :properties => {
          :id       => { :default => '', :description => 'Doc Id', :type => 'string' }
        }
      }
      return dSchema
    end

    def getDefaultDocument()
      dDocument = {}
      if @bDefaultifyDoc && @dSchema.has_key?(:properties)
        @dSchema[:properties].keys.each do |yKey|
          dProperty = @dSchema[:properties][yKey]
          xxVal     = dProperty.has_key?(:default) ? dProperty[:default] : ''
          dDocument[yKey] = xxVal
        end
      end
      return dDocument
    end

    def loadHash(dValues=nil)
      if dValues.nil?
        return
      elsif ! dValues.is_a?(Hash)
        raise ArgumentError, 'E_INITIAL_VALUES_IS_NOT_A_HASH'
      end
      dValues.each do |yKey,xxVal|
        self.setProp(yKey,xxVal)
      end
      return self
    end

    def getProp(yKey=nil)
      if yKey.nil?
        raise ArgumentError, 'E_BAD_KEY__IS_NIL'
      end
      yKey  = yKey.to_sym if yKey.kind_of?(String)
      aKeys = yKey.split('.')
      #aKeys = yKey.to_s.split('.').map(&:to_sym)

      dDoc  = @dDocument
      xxVal = getPropRecurse(aKeys.clone,dDoc)
      return xxVal
    end

    def getPropRecurse(aKeys=[],dDoc=nil)
      yKey = aKeys.shift
      if ! yKey.is_a?(Symbol) || yKey.length<1 || ! dDoc.has_key?( yKey )
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

    def getPropSingle(yKey=nil)
      if yKey.nil?
        raise ArgumentError, 'E_BAD_KEY__IS_NIL'
      end
      yKey  = yKey.to_sym if yKey.kind_of?(String)
      xxVal = @dDocument.has_key?(yKey) ? @dDocument[yKey] : nil
      if xxVal.nil? && @bIsStrict
        self.validateKey(yKey)
      end
      return xxVal
    end

    def validateKey(yKey=nil)
      if yKey.nil?
        raise ArgumentError, "E_BAD_KEY__IS_NIL [#{yKey.to_s}]"
      end

      return true unless @bIsStrict

      bKeyExists = @dSchema.has_key?(:properties) && @dSchema[:properties].has_key?(yKey) ? true : false

      unless bKeyExists
        raise ArgumentError, "E_UNKNOWN_KEY__STRICT #{yKey.to_s}"
      end

      return true
    end

    def setProp(yKey=nil,xxVal=nil)
      yKey = yKey.to_sym if yKey.kind_of?(String)

      self.validateKey(yKey)

      @dDocument[yKey] = xxVal
    end

    def pushProp(yKey=nil,xxVal=nil)
      yKey = yKey.to_sym if yKey.kind_of?(String)

      self.validateKey(yKey)

      if @dDocument.has_key?(yKey)
        if @dDocument[yKey].kind_of?(Array)
          @dDocument[yKey].push(xxVal)
        else
          raise RuntimeError, 'E_PROPERTY_IS_NOT_ARRAY'
        end
      else
        @dDocument[yKey] = [xxVal]
      end
    end

    def cpProp(yKeySrc=nil,yKeyDest=nil)
      yKeySrc  = yKeySrc.to_sym  if yKeySrc.kind_of?(String)
      yKeyDest = yKeyDest.to_sym if yKeyDest.kind_of?(String)
      self.setAttr(yKeyDest, self.getAttr(yKeySrc))
    end

    def sortKeys()
      @dDocument.keys.sort!
    end

    def fromJson(jDocument=nil)
      if jDocument.kind_of?(String)
        @dDocument = JSON.load(jDocument)
      end
      return self
    end

    def fromDict(dDocument=nil)
      @dDocument = dDocument if dDocument.is_a?(Hash)
    end

    def asHash()
      return @dDocument
    end

    def asJson()
      return JSON.dump( self.asHash() )
    end

    def getValStringForProperties(aCols=nil,sDelimiter="\t")
      sDelimiter = "\t" unless sDelimiter.kind_of?(String) && sDelimiter.length>0
      aVals = self.getValArrayForProperties(aCols)
      sVals = aVals.join(sDelimiter)
      return sVals
    end

    def getValArrayForProperties(aCols=nil,xxNil='')
      aVals = []
      return aVals if aCols.nil?

      if @bUseKeyAsDesc
        asVals = aCols.map {|x| x.to_s }
      end

      aCols.each do |yKey|

        yKey  = yKey.to_sym if yKey.kind_of?(String)
        xxVal = getProp( yKey )
        #xVal = @dDocument.has_key?(yKey) ? @dDocument[yKey] : nil
        xxVal = xxNil if xxVal.nil?
        aVals.push( xxVal )

      end
      return aVals
    end

    def getDescStringForProperties(aCols=nil,sDelimiter="\t")
      sDelimiter = "\t" unless sDelimiter.kind_of?(String) && sDelimiter.length>0
      aVals = self.getDescArrayForProperties(aCols)
      sVals = aVals.join(sDelimiter)
      return sVals
    end

    def getDescArrayForProperties(aCols=nil)
      aVals = []
      return aVals if aCols.nil?
      aCols.each do |yKey|

        yKey  = yKey.to_sym if yKey.kind_of?(String)
        xxVal = (
          @dSchema.has_key?(:properties)                          \
          && @dSchema[:properties].has_key?(yKey)                 \
          && @dSchema[:properties][yKey].has_key?(:description)   \
          && @dSchema[:properties][yKey][:description].length > 0
        ) \
          ? @dSchema[:properties][yKey][:description] : yKey.to_s

        xxVal = xxVal.to_s unless xxVal.is_a?(String)

        aVals.push( xxVal )
      end
      return aVals
    end

    alias_method :setAttr , :setProp
    alias_method :getAttr , :getProp
    alias_method :pushAttr, :pushProp
    alias_method :cpAttr  , :cpProp
  end
end
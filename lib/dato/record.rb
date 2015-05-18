module Dato
  class Record
    attr_reader :attributes

    def initialize(attributes, fields)
      @attributes, @fields = attributes, fields
    end

    def respond_to?(method, include_private = false)
      if @attributes.has_key?(method)
        true
      else
        super
      end
    end

    def method_missing(method, *arguments, &block)
      if @attributes.has_key?(method) && arguments.size == 0
        @attributes[method]
      else
        super
      end
    end
  end
end

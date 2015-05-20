require "dato/image"

module Dato
  class Record
    attr_reader :attributes, :fields

    def initialize(attributes, fields)
      @attributes = attributes.with_indifferent_access
      @fields = fields.with_indifferent_access
    end

    def respond_to?(method, include_private = false)
      if @attributes.has_key?(method)
        true
      else
        super
      end
    end

    def read_attribute(name)
      attribute = @attributes[name]

      attribute = if fields[name][:localized]
        attribute[I18n.locale]
      else
        attribute
      end

      if fields[name][:field_type] == "image"
        Image.new(attribute)
      else
        attribute
      end
    end

    def method_missing(method, *arguments, &block)
      if @attributes.has_key?(method) && arguments.size == 0
        read_attribute(method.to_sym)
      else
        super
      end
    end
  end
end

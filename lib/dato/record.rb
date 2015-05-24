require "dato/file"

module Dato
  class Record
    attr_reader :attributes, :fields, :singleton

    def initialize(attributes, content_type)
      @attributes = attributes.with_indifferent_access
      @singleton = content_type[:singleton]
      @fields = content_type[:fields].with_indifferent_access
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

      if %w(image file).include? fields[name][:field_type]
        Dato::File.new(attribute)
      elsif fields[name][:field_type] == "date"
        Date.parse(attribute)
      else
        attribute
      end
    end

    def id
      @attributes[:id]
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

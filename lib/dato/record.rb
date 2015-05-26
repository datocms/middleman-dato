require "dato/file"
require "dato/seo"
require "time"

module Dato
  class Record
    attr_reader :attributes, :fields, :content_type

    def initialize(attributes, content_type)
      @attributes = attributes.with_indifferent_access
      @content_type = content_type
      @fields = content_type[:fields].with_indifferent_access
    end

    def singleton?
      @singleton = content_type[:singleton]
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

      return nil if !attribute

      if %w(image file).include? fields[name][:field_type]
        Dato::File.new(attribute)
      elsif fields[name][:field_type] == "date"
        Date.parse(attribute)
      elsif fields[name][:field_type] == "seo"
        Dato::Seo.new(attribute)
      else
        attribute
      end
    end

    def id
      @attributes[:id]
    end

    def updated_at
      Time.parse(@attributes[:updated_at])
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

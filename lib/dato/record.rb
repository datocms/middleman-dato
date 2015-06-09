require 'active_support/core_ext/hash/indifferent_access'
require 'dato/field'

module Dato
  class Record
    attr_reader :attributes, :fields, :content_type

    def initialize(attributes, content_type)
      @attributes = attributes.with_indifferent_access
      @content_type = content_type
      @fields = content_type[:fields].with_indifferent_access
      @values = {}
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

    private

    def read_attribute(name)
      unless @values.has_key?(name)
        @values[name] = Field.value(attributes[name], fields[name])
      end
      @values[name]
    end
  end
end

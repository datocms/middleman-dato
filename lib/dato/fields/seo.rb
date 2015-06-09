require "imgix"

module Dato
  module Fields
    class Seo
      attr_reader :attributes

      def initialize(data)
        @attributes = data.with_indifferent_access
      end

      def image
        @attributes[:image] && File.new(@attributes[:image])
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
          @attributes[method.to_sym]
        else
          super
        end
      end

      def ==(other)
        attributes == other.attributes
      end
    end
  end
end

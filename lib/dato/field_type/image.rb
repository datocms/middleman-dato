require "dato/field_type/file"

module Dato
  module FieldType
    class Image < Dato::FieldType::File
      attr_reader :width, :height

      def self.parse(value, _repo)
        new(
          value[:path],
          value[:format],
          value[:size],
          value[:width],
          value[:height]
        )
      end

      def initialize(path, format, size, width, height)
        super(path, format, size)
        @width = width
        @height = height
      end
    end
  end
end

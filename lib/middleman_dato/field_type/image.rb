require 'middleman_dato/field_type/file'

module MiddlemanDato
  module FieldType
    class Image < MiddlemanDato::FieldType::File
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

      def file
        super.ch('DPR', 'Width').auto('compress', 'format')
      end
    end
  end
end

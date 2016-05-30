module MiddlemanDato
  module FieldType
    class Seo
      attr_reader :title, :description

      def self.parse(value, _repo)
        new(value[:title], value[:description], value[:image])
      end

      def initialize(title, description, image)
        @title = title
        @description = description
        @image = image
      end

      def image
        @image && Image.parse(@image, nil)
      end
    end
  end
end

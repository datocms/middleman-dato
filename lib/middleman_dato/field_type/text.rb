module MiddlemanDato
  module FieldType
    class Text
      def self.parse(value, _repo)
        value
      end
    end
  end
end

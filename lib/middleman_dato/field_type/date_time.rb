module MiddlemanDato
  module FieldType
    class DateTime
      def self.parse(value, _repo)
        ::Time.parse(value)
      end
    end
  end
end

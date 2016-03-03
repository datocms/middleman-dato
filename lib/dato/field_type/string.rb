module Dato
  module FieldType
    class String
      def self.parse(value, _repo)
        value
      end
    end
  end
end

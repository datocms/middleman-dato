module Dato
  module FieldType
    class Date
      def self.parse(value, _repo)
        ::Date.parse(value)
      end
    end
  end
end

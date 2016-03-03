module Dato
  module FieldType
    class Link
      def self.parse(value, repo)
        repo.find(value)
      end
    end
  end
end

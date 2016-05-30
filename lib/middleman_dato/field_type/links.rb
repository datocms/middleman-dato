module MiddlemanDato
  module FieldType
    class Links
      def self.parse(ids, repo)
        ids.map { |id| repo.find(id) }
      end
    end
  end
end

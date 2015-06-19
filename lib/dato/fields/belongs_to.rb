module Dato
  module Fields
    class BelongsTo
      attr_reader :attributes

      def initialize(data)
        @record_id = data
        field = field.with_indifferent_access
        @content_type = field[:record_content_type][:content_type]
      end

      def value
        Dato::Repo.instance.records_per_content_type
      end

      def ==(other)
        attributes == other.attributes
      end
    end
  end
end

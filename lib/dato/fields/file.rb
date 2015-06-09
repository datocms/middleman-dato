require "imgix"

module Dato
  module Fields
    class File
      attr_reader :attributes

      def initialize(data)
        @attributes = data.with_indifferent_access
      end

      def file
        @file ||= Imgix::Client.new(host: 'dato-images.imgix.net')
                .path(attributes[:path])
      end

      def ==(other)
        attributes == other.attributes
      end
    end
  end
end

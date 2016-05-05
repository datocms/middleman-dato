module Dato
  module FieldType
    class LatLon
      attr_reader :latitude, :longitude

      def self.parse(value, _repo)
        new(value[:latitude], value[:longitude])
      end

      def initialize(latitude, longitude)
        @latitude = latitude
        @longitude = longitude
      end

      def values
        [latitude, longitude]
      end
    end
  end
end

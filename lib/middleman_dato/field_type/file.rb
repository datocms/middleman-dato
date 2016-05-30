require 'imgix'

module MiddlemanDato
  module FieldType
    class File
      attr_reader :path, :format, :size

      def self.parse(value, _repo)
        new(
          value[:path],
          value[:format],
          value[:size]
        )
      end

      def initialize(path, format, size)
        @path = path
        @format = format
        @size = size
      end

      def file
        Imgix::Client.new(
          host: 'dato-images.imgix.net',
          secure: true
        ).path(path)
      end
    end
  end
end

require 'active_support/core_ext/hash/compact'
require 'video_embed'

module Dato
  module FieldType
    class Video
      def self.parse(value, _repo)
        new(value)
      end

      def initialize(attributes)
        @attributes = attributes
      end

      def url
        @attributes[:url]
      end

      def thumbnail_url
        @attributes[:thumbnail_url]
      end

      def title
        @attributes[:title]
      end

      def width
        @attributes[:width]
      end

      def height
        @attributes[:height]
      end

      def provider
        @attributes[:provider]
      end

      def provider_url
        @attributes[:provider_url]
      end

      def iframe_embed(width = nil, height = nil)
        VideoEmbed.embed(url, { width: width, height: height }.compact)
      end
    end
  end
end

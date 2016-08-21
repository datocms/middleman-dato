# frozen_string_literal: true
require 'middleman_dato/meta_tags/og_meta_tag'
require 'time'

module MiddlemanDato
  module MetaTags
    class ArticleModifiedTime < OgMetaTag
      def buildable?
        item && !item.singleton?
      end

      def name
        'article:modified_time'
      end

      def value
        item.updated_at.iso8601
      end
    end
  end
end

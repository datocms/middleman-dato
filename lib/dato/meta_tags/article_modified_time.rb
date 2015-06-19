require "dato/meta_tags/og_meta_tag"
require "time"

module Dato
  module MetaTags
    class ArticleModifiedTime < OgMetaTag
      def buildable?
        record && !record.singleton?
      end

      def name
        "article:modified_time"
      end

      def value
        record.updated_at.iso8601
      end
    end
  end
end

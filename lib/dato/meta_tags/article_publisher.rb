require 'dato/meta_tags/og_meta_tag'
require 'time'

module Dato
  module MetaTags
    class ArticlePublisher < OgMetaTag
      def buildable?
        record && !record.singleton? &&
        global_seo_field(:facebook_page_url).present?
      end

      def name
        "article:publisher"
      end

      def value
        global_seo_field(:facebook_page_url)
      end
    end
  end
end

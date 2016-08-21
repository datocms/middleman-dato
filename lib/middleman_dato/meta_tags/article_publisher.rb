# frozen_string_literal: true
require 'middleman_dato/meta_tags/og_meta_tag'
require 'time'

module MiddlemanDato
  module MetaTags
    class ArticlePublisher < OgMetaTag
      def buildable?
        item && !item.singleton? &&
          global_seo_field(:facebook_page_url).present?
      end

      def name
        'article:publisher'
      end

      def value
        global_seo_field(:facebook_page_url)
      end
    end
  end
end

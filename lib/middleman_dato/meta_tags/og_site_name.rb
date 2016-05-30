require 'middleman_dato/meta_tags/og_meta_tag'

module MiddlemanDato
  module MetaTags
    class OgSiteName < OgMetaTag
      def buildable?
        global_seo_field(:site_name).present?
      end

      def name
        'og:site_name'
      end

      def value
        global_seo_field(:site_name)
      end
    end
  end
end

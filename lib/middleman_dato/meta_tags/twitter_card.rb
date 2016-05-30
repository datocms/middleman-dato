require 'middleman_dato/meta_tags/twitter_meta_tag'

module MiddlemanDato
  module MetaTags
    class TwitterCard < TwitterMetaTag
      def buildable?
        true
      end

      def name
        'twitter:card'
      end

      def value
        'summary'
      end
    end
  end
end

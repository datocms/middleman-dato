require 'dato/meta_tags/base'

module Dato
  module MetaTags
    class Url < Base
      def build
        if url.present?
          [
            builder.tag(:link, rel: 'canonical', href: url),
            builder.tag(:meta, property: 'og:url', content: url),
            builder.tag(:meta, name: 'twitter:url', content: url)
          ]
        end
      end

      def url
        base_url + builder.current_page.url
      end
    end
  end
end

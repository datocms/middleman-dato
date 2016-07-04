require 'middleman_dato/meta_tags/base'

module MiddlemanDato
  module MetaTags
    class Image < Base
      def build
        if image.present?
          [
            builder.tag(:meta, property: 'og:image', content: image),
            builder.tag(:meta, name: 'twitter:image', content: image)
          ]
        end
      end

      def image
        image = seo_field_with_fallback(
          :image,
          first_item_field_of_type(:image)
        ) do |i|
          i.width >= 200 && i.height >= 200
        end

        image.file.format('jpg').to_url if image
      end
    end
  end
end

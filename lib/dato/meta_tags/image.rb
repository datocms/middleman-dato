require 'dato/meta_tags/base'

module Dato
  module MetaTags
    class Image < Base

      def build
        if image.present?
          [
            builder.tag(:meta, property: "og:image", content: image),
            builder.tag(:meta, name: "twitter:image", content: image)
          ]
        end
      end

      def image
        image = seo_field_with_fallback(
          :image,
          first_record_field_of_type(:image)
        ) do |image|
          image.attributes[:width] >= 200 &&
          image.attributes[:height] >= 200
        end

        if image
          image.file.format("jpg").to_url
        end
      end
    end
  end
end



require 'dato/meta_tags/base'

module Dato
  module MetaTags
    class Title < Base

      def build
        if title.present?
          [
            builder.content_tag(:title, title_with_suffix),
            builder.tag(:meta, property: "og:title", content: title),
            builder.tag(:meta, name: "twitter:title", content: title)
          ]
        end
      end

      def title
        @title ||= seo_field_with_fallback(
          :title,
          first_record_field_of_type(:title)
        )
      end

      def title_with_suffix
        title_plus_suffix = title + title_suffix

        if title_plus_suffix.size <= 60
          title_plus_suffix
        else
          title
        end
      end
    end
  end
end



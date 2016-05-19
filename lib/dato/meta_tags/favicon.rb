module Dato
  module MetaTags
    class Favicon
      attr_reader :builder, :theme_color, :favicon, :app_name
      APPLE_TOUCH_ICON_SIZES = [57, 60, 72, 76, 114, 120, 144, 152, 180]
      ICON_SIZES = [16, 32, 96, 192]
      APPLICATION_SIZES = [70, 150, 310]

      def initialize(builder, entity, theme_color)
        @favicon = entity.favicon
        @builder = builder
        @theme_color = theme_color
        @app_name = entity.global_seo["site_name"] || ""
      end

      def image
        if favicon.present?
          Dato::FieldType::Image.parse(favicon, nil)
        end
      end

      def url(width, height = nil)
        height ||= width
        image.file.width(width).height(height).to_url
      end

      def build_apple_icon_tags
        APPLE_TOUCH_ICON_SIZES.map do |size|
            builder.tag(:link,
                        rel: "apple-touch-icon",
                        sizes: "#{size}x#{size}",
                        href: self.url(size)
                       )
        end
      end

      def build_icon_tags
        ICON_SIZES.map do |size|
          builder.tag(:link,
                      rel: "icon",
                      type: "image/#{image.format}",
                      href: self.url(size),
                      sizes: "#{size}x#{size}"
                     )
        end
      end

      def build_application_tags
        APPLICATION_SIZES.map do |size|
          builder.tag(:meta,
                      name: "msapplication-square#{size}x#{size}logo",
                      content: self.url(size)
                     )
        end + [builder.tag(:meta, name: "msapplication-wide310x150logo", content: self.url(310, 150))]
      end

      def build_tags
        tags = []
        tags << builder.tag(:meta, name: "application-name", content: app_name)
        tags << builder.tag(:meta, name: "theme-color", content: theme_color)
        tags << builder.tag(:meta, name: "msapplication-TileColor", content: theme_color )
        unless image.nil?
          tags += build_apple_icon_tags
          tags += build_icon_tags
          tags += build_application_tags
        end
        tags
      end

      def build
        build_tags.join("\n")
      end
    end
  end
end

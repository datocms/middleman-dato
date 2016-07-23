require 'middleman-core'
require 'middleman-core/version'
require 'semantic'
require 'middleman_dato/meta_tags_builder'
require 'middleman_dato/site'
require 'middleman_dato/meta_tags/favicon'

module MiddlemanDato
  class MiddlemanExtension < ::Middleman::Extension
    attr_reader :site

    option :domain, nil, 'Site domain'
    option :token, nil, 'Site API token'
    option :api_host, 'https://site-api.datocms.com', 'Site API host'
    option :base_url, nil, 'Website base URL'

    if Semantic::Version.new(Middleman::VERSION).major >= 4
      expose_to_config dato: :dato
    end

    def initialize(app, options_hash = {}, &block)
      super

      @site = site = MiddlemanDato::Site.new(options)
      @site.refresh!

      app.before do
        site.refresh! if !build? && !ENV.fetch('DISABLE_DATO_REFRESH', false)
        true
      end

      if Semantic::Version.new(Middleman::VERSION).major <= 3
        app.send :include, InstanceMethods
      end
    end

    def dato
      site.items_repo
    end

    module InstanceMethods
      def dato
        extensions[:dato].site.items_repo
      end
    end

    helpers do
      def dato
        extensions[:dato].site.items_repo
      end

      def dato_meta_tags(item)
        builder = MetaTagsBuilder.new(
          self,
          extensions[:dato].options[:base_url],
          extensions[:dato].site.entity,
          item
        )
        builder.meta_tags
      end

      def dato_favicon_meta_tags(options = {})
        options[:theme_color] ||= '#ffffff'
        options[:app_name] ||= ''
        favicon_builder = MetaTags::Favicon.new(
          self,
          extensions[:dato].site.entity,
          options[:theme_color]
        )
        favicon_builder.build
      end
    end
  end
end

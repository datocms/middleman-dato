require 'middleman-core'
require 'middleman-core/version'
require 'semantic'
require 'middleman_dato/meta_tags_builder'
require 'middleman_dato/space'
require 'middleman_dato/meta_tags/favicon'

module MiddlemanDato
  class MiddlemanExtension < ::Middleman::Extension
    attr_reader :space

    option :domain, nil, 'Space domain'
    option :token, nil, 'Space API token'
    option :api_host, 'http://api.datocms.com', 'Space API token'
    option :base_url, nil, 'Website base URL'

    if Semantic::Version.new(Middleman::VERSION).major >= 4
      expose_to_config dato: :dato
    end

    def initialize(app, options_hash = {}, &block)
      super

      @space = space = MiddlemanDato::Space.new(options)
      @space.refresh!

      app.before do
        space.refresh! if !build? && !ENV.fetch('DISABLE_DATO_REFRESH', false)
        true
      end

      if Semantic::Version.new(Middleman::VERSION).major <= 3
        app.send :include, InstanceMethods
      end
    end

    def dato
      space.records_repo
    end

    module InstanceMethods
      def dato
        extensions[:dato].space.records_repo
      end
    end

    helpers do
      def dato
        extensions[:dato].space.records_repo
      end

      def dato_meta_tags(record)
        builder = MetaTagsBuilder.new(
          self,
          extensions[:dato].options[:base_url],
          extensions[:dato].space.entity,
          record
        )
        builder.meta_tags
      end

      def dato_favicon_meta_tags(options = {})
        options[:theme_color] ||= '#ffffff'
        options[:app_name] ||= ''
        favicon_builder = MetaTags::Favicon.new(
          self,
          extensions[:dato].space.entity,
          options[:theme_color]
        )
        favicon_builder.build
      end
    end
  end
end
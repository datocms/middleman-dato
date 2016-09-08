# frozen_string_literal: true
require 'middleman-core'
require 'middleman-core/version'
require 'semantic'
require 'dato/site/client'
require 'dato/local/loader'
require 'middleman_dato/meta_tags_builder'
require 'middleman_dato/meta_tags/favicon'

module MiddlemanDato
  class MiddlemanExtension < ::Middleman::Extension
    attr_reader :loader

    option :domain, nil, 'Site domain (legacy)'
    option :token, nil, 'Site API token'
    option :api_base_url, 'https://site-api.datocms.com', 'Site API host'
    option :base_url, nil, 'Website base URL'

    if Semantic::Version.new(Middleman::VERSION).major >= 4
      expose_to_config dato: :dato
    end

    def initialize(app, options_hash = {}, &block)
      super

      @loader = loader = Dato::Local::Loader.new(client)
      @loader.load

      app.before do
        loader.load if !build? && !ENV.fetch('DISABLE_DATO_REFRESH', false)
        true
      end

      if Semantic::Version.new(Middleman::VERSION).major <= 3
        app.send :include, InstanceMethods
      end
    end

    def client
      @client ||= Dato::Site::Client.new(
        options[:token],
        base_url: options[:api_base_url],
        extra_headers: {
          'X-Reason' => 'dump',
          'X-SSG' => 'middleman'
        }
      )
    end

    def dato
      loader.items_repo
    end

    module InstanceMethods
      def dato
        extensions[:dato].loader.items_repo
      end
    end

    helpers do
      def dato
        extensions[:dato].loader.items_repo
      end

      def dato_meta_tags(item)
        site_entity = extensions[:dato].loader
          .entities_repo
          .find_entities_of_type('site')
          .first

        builder = MetaTagsBuilder.new(
          self,
          extensions[:dato].options[:base_url],
          site_entity,
          item
        )
        builder.meta_tags
      end

      def dato_favicon_meta_tags(options = {})
        site_entity = extensions[:dato].loader
          .entities_repo
          .find_entities_of_type('site')
          .first

        options[:theme_color] ||= '#ffffff'
        options[:app_name] ||= ''

        favicon_builder = MetaTags::Favicon.new(
          self,
          site_entity,
          options[:theme_color]
        )
        favicon_builder.build
      end
    end
  end
end

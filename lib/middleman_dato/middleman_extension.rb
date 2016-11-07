# frozen_string_literal: true
require 'middleman-core'
require 'middleman-core/version'
require 'semantic'
require 'dato/site/client'
require 'dato/local/loader'
require 'middleman_dato/meta_tags_builder'
require 'middleman_dato/meta_tags/favicon'
require 'pusher-client'
require 'fileutils'

module MiddlemanDato
  class MiddlemanExtension < ::Middleman::Extension
    attr_reader :loader

    option :domain, nil, 'Site domain (legacy)'
    option :token, nil, 'Site API token'
    option :api_base_url, 'https://site-api.datocms.com', 'Site API host'
    option :base_url, nil, 'Website base URL'

    if Semantic::Version.new(Middleman::VERSION).major >= 4
      expose_to_config dato: :dato_collector
      expose_to_application dato_items_repo: :items_repo
    end

    def initialize(app, options_hash = {}, &block)
      super

      @loader = loader = Dato::Local::Loader.new(client)
      @loader.load

      app.after_configuration do
        Thread.new do
          PusherClient.logger.level = Logger::WARN
          socket = PusherClient::Socket.new(
            '75e6ef0fe5d39f481626',
            secure: true,
          )
          socket.subscribe("site-#{loader.items_repo.site.id}")
          socket.bind('site:change') do
            puts "Refresh!"
            loader.load
            app.sitemap.rebuild_resource_list!(:touched_dato_content)
          end
          socket.connect
        end
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

    def dato_collector
      app.extensions[:collections].live_collector do |app, resources|
        app.dato_items_repo
      end
    end

    def items_repo
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

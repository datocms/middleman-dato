# frozen_string_literal: true
require 'middleman-core'
require 'middleman-core/version'
require 'dato/site/client'
require 'dato/local/loader'
require 'dato/watch/site_change_watcher'
require 'middleman_dato/watcher'
require 'dato/utils/seo_tags_builder'
require 'dato/utils/favicon_tags_builder'

module MiddlemanDato
  class MiddlemanExtension < ::Middleman::Extension
    attr_reader :loader

    option :token, ENV['DATO_API_TOKEN'], 'Site API token'
    option :api_base_url, 'https://site-api.datocms.com', 'Site API host'
    option :live_reload, true, 'Live reload of content coming from DatoCMS'

    option :base_url, nil, 'Website base URL (deprecated)'
    option :domain, nil, 'Site domain (deprecated)'

    expose_to_config dato: :dato_collector
    expose_to_application dato_items_repo: :items_repo

    def initialize(app, options_hash = {}, &block)
      super

      @loader = loader = Dato::Local::Loader.new(client)
      @loader.load

      app.after_configuration do
        if options[:live_reload] && !app.build?
          Watcher.instance.watch(app, loader, loader.items_repo.site.id)
        end
      end

      app.before_shutdown do
        if options[:live_reload] && !app.build?
          Watcher.instance.shutdown(app)
        end
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
        extensions[:dato].items_repo
      end
    end

    helpers do
      def dato
        extensions[:dato].items_repo
      end

      def dato_meta_tags(item)
        meta_tags = Dato::Utils::SeoTagsBuilder.new(item, dato.site).meta_tags

        meta_tags.map do |data|
          if data[:content]
            content_tag(data[:tag_name], data[:content], data[:attributes])
          else
            tag(data[:tag_name], data[:attributes])
          end
        end.join
      end

      def dato_favicon_meta_tags(options = {})
        meta_tags = Dato::Utils::FaviconTagsBuilder.new(
          dato.site,
          options[:theme_color]
        )

        meta_tags.map do |data|
          if data[:content]
            content_tag(data[:tag_name], data[:content], data[:attributes])
          else
            tag(data[:tag_name], data[:attributes])
          end
        end.join
      end
    end
  end
end

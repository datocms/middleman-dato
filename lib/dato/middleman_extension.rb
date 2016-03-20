require 'middleman-core'
require 'dato/space'
require 'dato/meta_tags_builder'

module Dato
  class MiddlemanExtension < ::Middleman::Extension
    attr_reader :space

    option :domain, nil, 'Space domain'
    option :token, nil, 'Space API token'
    option :api_host, 'http://api.datocms.com', 'Space API token'
    option :base_url, nil, 'Website base URL'

    def initialize(app, options_hash = {}, &block)
      super

      @space = space = Dato::Space.new(options)
      @space.refresh!

      app.before do
        space.refresh! if !build? && !ENV.fetch('DISABLE_DATO_REFRESH', false)
        true
      end

      app.send :include, InstanceMethods
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
    end
  end
end

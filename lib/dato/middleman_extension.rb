require 'middleman-core'
require 'dato/repo'
require 'dato/meta_tags_builder'
require 'ostruct'

module Dato
  class MiddlemanExtension < ::Middleman::Extension
    option :domain, nil, 'Space domain'
    option :token, nil, 'Space API token'
    option :api_host, 'http://dato-api.herokuapp.com', 'Space API token'
    option :base_url, nil, 'Website base URL'

    attr_reader :records

    def initialize(app, options_hash={}, &block)
      super

      Repo.instance.connection_options = options
      Repo.instance.sync!

      app.before do
        unless build?
          print "Syncing Dato space... "
          Repo.instance.sync!
          puts "done."
        end
        true
      end

      app.send :include, InstanceMethods
    end

    module InstanceMethods
      def dato
        OpenStruct.new(Repo.instance.records_per_content_type)
      end
    end

    helpers do
      def dato
        OpenStruct.new(Repo.instance.records_per_content_type)
      end

      def dato_meta_tags(record)
        begin
          builder = MetaTagsBuilder.new(
            self,
            Repo.instance.connection_options[:base_url],
            Repo.instance.space,
            record
          )
          builder.meta_tags
        rescue Exception => e
          puts e.message
          puts e.backtrace.join("\n")
        end
      end
    end
  end
end

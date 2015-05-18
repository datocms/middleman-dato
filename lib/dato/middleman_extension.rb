require 'middleman-core'
require 'dato/repo'
require 'ostruct'

module Dato
  class MiddlemanExtension < ::Middleman::Extension
    option :domain, nil, 'Space domain'
    option :token, nil, 'Space API token'
    option :api_host, 'http://dato-api.herokuapp.com', 'Space API token'

    attr_reader :records

    def initialize(app, options={}, &block)
      super

      Repo.instance.connection_options = options

      app.before do
        Repo.instance.sync!
        true
      end
    end

    helpers do
      def dato
        OpenStruct.new(Repo.instance.records_per_content_type)
      end
    end
  end
end

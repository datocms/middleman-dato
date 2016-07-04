# coding: utf-8
require 'middleman_dato/client'
require 'middleman_dato/entities_repo'
require 'middleman_dato/items_repo'

module MiddlemanDato
  class Site
    attr_reader :options
    attr_reader :entities_repo
    attr_reader :items_repo

    def initialize(options)
      @options = options
      @entities_repo = EntitiesRepo.new
      @items_repo = ItemsRepo.new(@entities_repo)
    end

    def refresh!
      @entities_repo = EntitiesRepo.new(client.site, client.items)
      @items_repo = ItemsRepo.new(@entities_repo)
    end

    def entity
      @entities_repo.find_entities_of_type('site').first
    end

    private

    def client
      @client ||= Client.new(
        options[:api_host],
        options[:domain],
        options[:token]
      )
    end
  end
end

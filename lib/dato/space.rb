# coding: utf-8
require 'dato/client'
require 'dato/entities_repo'
require 'dato/records_repo'

module Dato
  class Space
    attr_reader :options
    attr_reader :entities_repo
    attr_reader :records_repo

    def initialize(options)
      @options = options
      @entities_repo = EntitiesRepo.new
      @records_repo = RecordsRepo.new(@entities_repo)
    end

    def refresh!
      @entities_repo = EntitiesRepo.new(client.space, client.records)
      @records_repo = RecordsRepo.new(@entities_repo)
    end

    def entity
      @entities_repo.find_entities_of_type('space').first
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

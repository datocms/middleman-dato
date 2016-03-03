require 'active_support/core_ext/string'
require 'dato/record'

module Dato
  class RecordsRepo
    attr_reader :entities_repo, :collections_by_type

    def initialize(entities_repo)
      @entities_repo = entities_repo
      @collections_by_type = {}

      build_collections_by_type!
    end

    def find(id)
      collections_by_type.values.flatten.find do |record|
        record && record.id == id
      end
    end

    def respond_to?(method, include_private = false)
      if collections_by_type.key?(method)
        true
      else
        super
      end
    end

    private

    def content_type_key(content_type)
      api_key = content_type.api_key
      if content_type.singleton
        [api_key.to_sym, true]
      else
        [api_key.pluralize.to_sym, false]
      end
    end

    def build_collections_by_type!
      content_type_entities.each do |content_type|
        key, singleton = content_type_key(content_type)
        @collections_by_type[key] = if singleton
                                      nil
                                    else
                                      RecordCollection.new
                                    end
      end

      record_entities.each do |record_entity|
        record = Record.new(record_entity, self)

        key, singleton = content_type_key(record_entity.content_type)
        if singleton
          @collections_by_type[key] = record
        else
          @collections_by_type[key].push record
        end
      end
    end

    def content_type_entities
      entities_repo.find_entities_of_type('content_type')
    end

    def record_entities
      entities_repo.find_entities_of_type('record')
    end

    def method_missing(method, *arguments, &block)
      if collections_by_type.key?(method) && arguments.empty?
        collections_by_type[method]
      else
        super
      end
    end

    class RecordCollection < Array
      def each(&block)
        if block && block.arity == 2
          each_with_object({}) do |record, acc|
            acc[record.id] = record
          end.each(&block)
        else
          super(&block)
        end
      end

      def [](id)
        if id.is_a? String
          find { |record| record.id == id }
        else
          super(id)
        end
      end

      def keys
        map(&:id)
      end

      def values
        to_a
      end
    end
  end
end

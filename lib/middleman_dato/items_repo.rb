require 'active_support/core_ext/string'
require 'middleman_dato/item'

module MiddlemanDato
  class ItemsRepo
    attr_reader :entities_repo, :collections_by_type

    def initialize(entities_repo)
      @entities_repo = entities_repo
      @collections_by_type = {}
      @items_by_id = {}

      build_cache!
    end

    def find(id)
      @items_by_id[id]
    end

    def respond_to?(method, include_private = false)
      if collections_by_type.key?(method)
        true
      else
        super
      end
    end

    private

    def item_type_key(item_type)
      api_key = item_type.api_key
      if item_type.singleton
        [api_key.to_sym, true]
      else
        [api_key.pluralize.to_sym, false]
      end
    end

    def build_cache!
      item_type_entities.each do |item_type|
        key, singleton = item_type_key(item_type)
        @collections_by_type[key] = if singleton
                                      nil
                                    else
                                      ItemCollection.new
                                    end
      end

      item_entities.each do |item_entity|
        item = Item.new(item_entity, self)

        key, singleton = item_type_key(item_entity.item_type)
        if singleton
          @collections_by_type[key] = item
        else
          @collections_by_type[key].push item
        end

        @items_by_id[item.id] = item
      end
    end

    def item_type_entities
      entities_repo.find_entities_of_type('item_type')
    end

    def item_entities
      entities_repo.find_entities_of_type('item')
    end

    def method_missing(method, *arguments, &block)
      if collections_by_type.key?(method) && arguments.empty?
        collections_by_type[method]
      else
        super
      end
    end

    class ItemCollection < Array
      def each(&block)
        if block && block.arity == 2
          each_with_object({}) do |item, acc|
            acc[item.id] = item
          end.each(&block)
        else
          super(&block)
        end
      end

      def [](id)
        if id.is_a? String
          find { |item| item.id == id }
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

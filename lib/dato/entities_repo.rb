require 'dato/json_api_entity'

module Dato
  class EntitiesRepo
    attr_reader :entities

    def initialize(*payloads)
      @entities = {}

      payloads.each do |payload|
        EntitiesRepo.payload_entities(payload).each do |entity_payload|
          object = JsonApiEntity.new(entity_payload, self)
          @entities[object.type] ||= {}
          @entities[object.type][object.id] = object
        end
      end
    end

    def find_entities_of_type(type)
      entities.fetch(type, {}).values
    end

    def find_entity(type, id)
      entities.fetch(type, {}).fetch(id, nil)
    end

    def self.payload_entities(payload)
      acc = []

      if payload[:data]
        acc = if payload[:data].is_a? Array
                acc + payload[:data]
              else
                acc + [payload[:data]]
              end
      end

      acc += payload[:included] if payload[:included]

      acc
    end
  end
end

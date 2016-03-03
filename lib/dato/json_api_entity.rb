module Dato
  class JsonApiEntity
    attr_reader :payload, :data_source

    def initialize(payload, data_source)
      @payload = payload
      @data_source = data_source
    end

    def id
      @payload[:id]
    end

    def type
      @payload[:type]
    end

    def ==(other)
      if other.is_a? JsonApiEntity
        id == other.id && type == other.type
      else
        false
      end
    end

    def to_s
      "#<JsonApiEntity id=#{id} type=#{type} payload=#{payload}>"
    end
    alias inspect to_s

    def [](key)
      attributes[key]
    end

    def respond_to?(method, include_private = false)
      if attributes.key?(method) || links.key?(method)
        true
      else
        super
      end
    end

    private

    def attributes
      @payload.fetch(:attributes, {})
    end

    def links
      @payload.fetch(:links, {})
    end

    def dereference_linkage(linkage)
      if linkage.is_a? Array
        linkage.map do |item|
          data_source.find_entity(item[:type], item[:id])
        end
      else
        data_source.find_entity(linkage[:type], linkage[:id])
      end
    end

    def method_missing(method, *arguments, &block)
      return super unless arguments.empty?

      if attributes.key?(method)
        attributes[method]
      elsif links.key?(method)
        dereference_linkage(links[method][:linkage])
      else
        super
      end
    end
  end
end

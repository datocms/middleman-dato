require 'forwardable'
require 'active_support/inflector/transliterate'
require 'active_support/hash_with_indifferent_access'

Dir[File.dirname(__FILE__) + '/field_type/*.rb'].each do |file|
  require file
end

module MiddlemanDato
  class Item
    extend Forwardable

    attr_reader :entity
    def_delegators :entity, :id, :type, :item_type

    def initialize(entity, items_repo)
      @entity = entity
      @items_repo = items_repo
    end

    def ==(item)
      item.is_a?(Item) && item.id == id
    end

    def slug
      if singleton?
        item_type.api_key.humanize.parameterize
      elsif title_attribute
        title = send(title_attribute)
        if title
          "#{id}-#{title.parameterize[0..50]}"
        else
          id.to_s
        end
      else
        id.to_s
      end
    end

    def singleton?
      item_type.singleton
    end

    def item_type
      @item_type ||= entity.item_type
    end
    alias_method :content_type, :item_type

    def fields
      @fields ||= item_type.fields.sort_by(&:position)
    end

    def attributes
      @attributes ||= fields.each_with_object(
        ActiveSupport::HashWithIndifferentAccess.new
      ) do |field, acc|
        acc[field.api_key.to_sym] = send(field.api_key)
      end
    end

    def position
      entity.position
    end

    def updated_at
      Time.parse(entity.updated_at)
    end

    def to_s
      api_key = item_type.api_key
      "#<Item id=#{id} item_type=#{api_key} attributes=#{attributes}>"
    end
    alias inspect to_s

    def title_attribute
      title_field = fields.find do |field|
        field.field_type == 'string' &&
          field.appeareance[:type] == 'title'
      end
      title_field && title_field.api_key
    end

    def respond_to?(method, include_private = false)
      field = fields.find { |f| f.api_key.to_sym == method }
      if field
        true
      else
        super
      end
    end

    private

    def read_attribute(method, field)
      field_type = field.field_type
      type_klass_name = "::MiddlemanDato::FieldType::#{field_type.camelize}"
      type_klass = type_klass_name.safe_constantize

      if type_klass
        value = if field.localized
                  (entity.send(method) || {})[I18n.locale]
                else
                  entity.send(method)
                end

        value && type_klass.parse(value, @items_repo)
      else
        raise "Cannot convert field `#{method}` of type `#{field_type}`"
      end
    end

    def method_missing(method, *arguments, &block)
      field = fields.find { |f| f.api_key.to_sym == method }
      if field && arguments.empty?
        read_attribute(method, field)
      else
        super
      end
    end
  end
end

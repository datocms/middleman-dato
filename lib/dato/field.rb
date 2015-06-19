require "active_support/core_ext/hash/indifferent_access"
require "dato/repo"
require "dato/fields/file"
require "dato/fields/seo"
require "time"

module Dato
  class Field
    class << self
      def value(attribute, field)
        attribute = translated_attribute(attribute, field)
        converted_attribute(attribute, field) if attribute
      end

      private

      def translated_attribute(attribute, field)
        field[:localized] ? attribute[I18n.locale.to_sym] : attribute
      end

      def converted_attribute(attribute, field)
        if factory = field_mappings[field[:field_type].to_sym]
          factory.call(attribute)
        else
          attribute
        end
      end

      def field_mappings
        {
          image: Dato::Fields::File.method(:new),
          file: Dato::Fields::File.method(:new),
          date: Date.method(:parse),
          seo: Dato::Fields::Seo.method(:new),
          belongs_to_one: Dato::Repo.instance.method(:find),
          embeds_one: Dato::Repo.instance.method(:find),
          belongs_to_many: Dato::Repo.instance.method(:find_all),
          embeds_many: Dato::Repo.instance.method(:find_all)
        }
      end
    end
  end
end

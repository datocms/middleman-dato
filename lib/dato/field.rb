require 'active_support/core_ext/hash/indifferent_access'
require 'dato/repo'
require "dato/fields/file"
require "dato/fields/seo"
require "time"

module Dato
  class Field
    TYPES = {
      image: Dato::Fields::File.method(:new),
      file:  Dato::Fields::File.method(:new),
      date:  Date.method(:parse),
      seo:   Dato::Fields::Seo.method(:new),
      belongs_to: Dato::Repo.instance.method(:find),
    }

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
        if factory = TYPES[field[:field_type].to_sym]
          factory.call(attribute)
        else
          attribute
        end
      end
    end
  end
end

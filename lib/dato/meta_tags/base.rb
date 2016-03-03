require 'forwardable'
require 'dato/field_type/seo'

module Dato
  module MetaTags
    class Base
      attr_reader :builder, :base_url, :space, :content_type, :record

      def initialize(builder, base_url, space, record)
        @space = space
        @base_url = base_url
        @record = record
        @builder = builder
      end

      def seo_field_with_fallback(attribute, alternative = nil, &block)
        seo = first_record_field_of_type(:seo)

        alternatives = []

        alternatives << seo.send(attribute) if seo
        alternatives << alternative if alternative
        alternatives << fallback_seo.send(attribute) if fallback_seo

        alternatives = alternatives.select(&:present?)
        alternatives = alternatives.select(&block) if block

        alternatives.first
      end

      def title_suffix
        global_seo_field(:title_suffix) || ''
      end

      def no_index?
        space && space.no_index
      end

      def global_seo_field(attribute)
        global_seo[attribute] if global_seo
      end

      def first_record_field_of_type(type)
        return nil unless record

        field = record.fields.detect do |f|
          f.field_type == type.to_s
        end

        record.send(field.api_key) if field
      end

      def fallback_seo
        @fallback_seo ||= begin
          FieldType::Seo.parse(global_seo[:fallback_seo], nil) if global_seo
        end
      end

      def global_seo
        @global_seo ||= begin
          if space && space.global_seo
            global_seo = space.global_seo
            if space.locales.size > 1
              global_seo[I18n.locale]
            else
              global_seo
            end
          end
        end
      end
    end
  end
end

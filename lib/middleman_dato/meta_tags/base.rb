# frozen_string_literal: true
require 'forwardable'
require 'dato/local/field_type/seo'
require 'active_support/core_ext/object/blank'

module MiddlemanDato
  module MetaTags
    class Base
      attr_reader :builder, :base_url, :site, :item_type, :item

      def initialize(builder, base_url, site, item)
        @site = site
        @base_url = base_url
        @item = item
        @builder = builder
      end

      def seo_field_with_fallback(attribute, alternative = nil, &block)
        seo = first_item_field_of_type(:seo)

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
        site && site.no_index
      end

      def global_seo_field(attribute)
        global_seo[attribute] if global_seo
      end

      def first_item_field_of_type(type)
        return nil unless item

        field = item.fields.detect do |f|
          f.field_type == type.to_s
        end

        item.send(field.api_key) if field
      end

      def fallback_seo
        @fallback_seo ||= begin
          Dato::Local::FieldType::Seo.parse(global_seo[:fallback_seo], nil) if global_seo
        end
      end

      def global_seo
        @global_seo ||= begin
          if site && site.global_seo
            global_seo = site.global_seo
            if site.locales.size > 1
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

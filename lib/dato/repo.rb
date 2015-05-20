require 'singleton'
require 'active_support/inflector/methods'
require 'dato/client'
require 'dato/record'

module Dato
  class Repo
    include Singleton

    attr_reader :client, :records_per_content_type

    def connection_options=(options)
      @client = Client.new(
        options.fetch(:api_host),
        options.fetch(:domain),
        options.fetch(:token)
      )
    end

    def sync!
      @content_types = prepare_content_types(client.space)
      @records_per_content_type = group_by_content_type(client.records)
    end

    def prepare_content_types(data)
      data = data.with_indifferent_access

      content_types = Hash[
        data[:data][:links][:content_types][:linkage]
          .map do |content_type|
            [
              content_type[:id],
              content_type_fields(content_type[:id], data[:included])
            ]
          end
      ]
    end

    def content_type_fields(content_type, data)
      content_type = data
        .find do |item|
          item[:type] == "content_type" && item[:id] == content_type
        end

      field_ids = content_type[:links][:fields][:linkage]
        .map { |field| field[:id] }

      Hash[
        data
          .select do |item|
            item[:type] == "field" && field_ids.include?(item[:id])
          end
          .map do |field|
            [
              field[:attributes][:api_key],
              field[:attributes]
            ]
          end
      ]
    end

    def group_by_content_type(data)
      Hash[
        data
          .with_indifferent_access[:data]
          .group_by do |record|
            record[:links][:content_type][:linkage][:id].pluralize
          end
          .map do |content_type, records|
            [ content_type, group_by_id(records) ]
          end
      ]
    end

    def group_by_id(records)
      Hash[
        records
          .group_by { |record| record[:id] }
          .map do |id, records|
            [ id, normalize_record(records.first) ]
          end
      ]
    end

    def normalize_record(record)
      content_type = record[:links][:content_type][:linkage][:id]

      Record.new(
        record[:attributes].merge(id: record[:id]),
        @content_types[content_type]
      )
    end
  end
end

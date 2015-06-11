require 'singleton'
require 'active_support/inflector/methods'
require 'dato/client'
require 'dato/record'

module Dato
  class Repo
    include Singleton

    attr_reader :client, :space, :content_types, :records_per_content_type,
      :connection_options

    def connection_options=(options)
      @connection_options = options
      @client = Client.new(
        options[:api_host],
        options[:domain],
        options[:token]
      )
    end

    def sync!
      space_response = client.space.with_indifferent_access
      @space = space_response[:data]
      @content_types = prepare_content_types(space_response)
      @records_per_content_type = group_by_content_type(client.records)
    end

    def prepare_content_types(data)
      data = data.with_indifferent_access

      content_types = Hash[
        data[:data][:links][:content_types][:linkage]
          .map do |content_type|
            [
              content_type[:id],
              content_type_data(content_type[:id], data[:included])
            ]
          end
      ]
    end

    def content_type_data(content_type, data)
      content_type = data
        .find do |item|
          item[:type] == "content_type" && item[:id] == content_type
        end

      field_ids = content_type[:links][:fields][:linkage]
        .map { |field| field[:id] }

      fields = Hash[
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

      {
        singleton: content_type[:attributes][:singleton],
        fields: fields
      }
    end

    def find(id)
      record = client.records[:data].find { |r| r[:id] == id }
      normalize_record(record) unless record.nil?
    end

    def group_by_content_type(data)
      Hash[
        content_types.map do |id, content_type|
          records = data
            .with_indifferent_access[:data]
            .select do |record|
              record[:links][:content_type][:linkage][:id] == id
            end

          if content_type[:singleton]
            [ id, records.any? ? normalize_record(records.first) : nil ]
          else
            [ id.pluralize, group_by_id(records) ]
          end
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
        content_types[content_type]
      )
    end
  end
end

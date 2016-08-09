require 'faraday'
require 'faraday_middleware'
require 'json'
require 'active_support/core_ext/hash/indifferent_access'

module MiddlemanDato
  class Client
    def initialize(host, token)
      @host = host
      @token = token
    end

    def site
      include = [
        'item_types',
        'item_types.fields'
      ]
      get('site', include: include).body.with_indifferent_access
    end

    def items
      items_per_page = 500
      base_response = get('items', 'page[limit]' => 1).body.
        with_indifferent_access

      pages = (base_response[:meta][:total_count] / items_per_page.to_f).ceil
      base_response[:data] = []

      pages.times do |page|
        base_response[:data] += get(
          'items',
          'page[offset]' => items_per_page * page,
          'page[limit]' => items_per_page
        ).body.with_indifferent_access[:data]
      end

      base_response
    end

    def get(*args)
      connection.get(*args)
    rescue Faraday::ClientError => e
      body = JSON.parse(e.response[:body])
      puts JSON.pretty_generate(body)
      raise e
    end

    def connection
      options = {
        url: @host,
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'Authorization' => "Api-Key #{@token}"
        }
      }
      @connection ||= Faraday.new(options) do |c|
        c.request :json
        c.response :json, item_type: /\bjson$/
        c.response :raise_error
        c.use FaradayMiddleware::FollowRedirects
        c.adapter :net_http
      end
    end
  end
end

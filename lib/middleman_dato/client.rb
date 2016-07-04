require 'faraday'
require 'faraday_middleware'
require 'json'
require 'active_support/core_ext/hash/indifferent_access'

module MiddlemanDato
  class Client
    def initialize(host, domain, token)
      @host = host
      @domain = domain
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
      get('items', 'page[limit]' => 10_000).body.with_indifferent_access
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
          'X-Site-Domain' => @domain,
          'Authorization' => "Api-Key #{@token}"
        }
      }
      @connection ||= Faraday.new(options) do |c|
        c.request :json
        c.response :json, item_type: /\bjson$/
        c.response :raise_error
        c.adapter :net_http
      end
    end
  end
end

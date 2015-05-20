require "faraday"
require "faraday_middleware"
require "json"

module Dato
  class Client
    def initialize(host, domain, token)
      @host, @domain, @token = host, domain, token
    end

    def space
      get("space").body
    end

    def records
      get("records").body
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
          "Content-Type"   => "application/json",
          "Accept"         => "application/json",
          "X-Space-Domain" => @domain,
          "Authorization"  => "Api-Key #{@token}"
        }
      }
      @connection ||= Faraday.new(options) do |c|
        c.request :json
        c.response :json, content_type: /\bjson$/
        c.response :raise_error
        c.adapter :net_http
      end
    end
  end
end

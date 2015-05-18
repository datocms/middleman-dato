require "faraday"
require "faraday_middleware"

module Dato
  class Client
    extend Forwardable
    def_delegators :connection, :get

    def initialize(host, domain, token)
      @host, @domain, @token = host, domain, token
    end

    def space
      get("space").body
    end

    def records
      get("records").body
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

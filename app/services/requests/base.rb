# frozen_string_literal: true

require 'faraday'
require 'uri'

module Requests
  # Base Class for requests
  class Base
    BASE_URL = ENV.fetch('BASE_URL')

    private

    # A helper method that crafts the connection for api-gateway.
    def connection_setup
      Faraday.new do |conn|
        conn.request :json
        conn.response :json, parser_options: { symbolize_names: true }
        conn.adapter Faraday.default_adapter
        conn.use Faraday::Request::UrlEncoded
        conn.headers['Content-Type'] = 'application/json'
      end
    end

    def remote_host
      @remote_host ||= URI(BASE_URL).host
    end

    def parse_response_body(response:)
      JSON(response.body).with_indifferent_access
    end
  end
end

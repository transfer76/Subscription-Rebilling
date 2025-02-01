# frozen_string_literal: true

require 'faraday_middleware'
require 'logger'

module Requests
  # Class is responsible for payment request
  class PaymentService < ::Requests::Base
    PAYMENT_URL = '/paymentIntents/create'

    def initialize(subscription:, logger: Logger.new('logs/rebill.log'))
      @amount = subscription.amount
      @subscription_id = subscription.id
      @logger = logger
    end

    # Invocation method
    # returns ActiveSupport::HashWithIndifferentAccess
    # Example:
    # {
    #   status: 'SUCCESS', 'INSUFFICIENT_FUNDS', 'FAILED'
    #   total_left_ballance: 100
    def self.call
      parse_response_body(response: make_request)
    end

    private

    def make_request
      response = connection_setup.post(remote_uri, @request_params.to_json)

      log_request(response_body: response_body)

      response
    end

    def remote_path
      @remote_path ||= PAYMENT_URL
    end

    def request_params
      @request_params ||= {
        amount: @amount,
        subscription_id: @subscription_id
      }
    end

    def remote_uri
      @remote_uri ||= URI::HTTPS.build(
        host: remote_host,
        path: remote_path
      )
    end

    def log_request(response_body:)
      @logger.info(
        'PAYMENT_REQUEST. ' \
        "Uri: #{remote_uri}, " \
        "Params: #{@request_params.to_json}, " \
        "Response: #{response_body}"
      )
    end
  end
end

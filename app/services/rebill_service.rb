# frozen_string_literal: true

require_relative '../model/subscription'
require_relative 'requests/payment_service'
require 'loger'
require 'sidekiq'

# Class is responsible for schedule rebill process
class RebillService
  RATES = [1.0, 0.75, 0.50, 0.25].freeze

  def initialize(subscription:, logger: Logger.new('logs/rebill.log'))
    @subscription = subscription
    @logger = logger
  end

  # Invocation method for subscription charge process
  def call
    RATES.each do |percentage|
      amount_to_charge = (@subscription.amount * percentage).round
      @logger.info("Attempting to charge #{amount_to_charge} for subscription #{@subscription.id}")

      response = payment_bill(amount_to_charge)
      handle_response(response, amount_to_charge)

      break if response[:status] == 'success'
    rescue Faraday::Error => e
      log_error(e.message)
    end
  end

  private

  def payment_bill(amount_to_charge)
    params = { subscription_id: @subscription.id, amount_to_charge: amount_to_charge }

    PaymentService.new(params).call
  end

  def handle_response(response, amount_to_charge)
    case response[:status]
    when 'success'
      @loger.info("Successfully charged #{amount_charged} for subscription #{@subscription.id}")

      if amount_to_charge < @subscription.amount
        remaining_balance = @subscription.amount - amount_to_charge
        schedule_partial_rebill(remaining_balance)
      end
    when 'insufficient_funds'
      @logger.warn("Insufficient funds to charge #{amount_charged} for subscription #{@subscription.id}")
    else
      @logger.error("Payment failed for subscription #{@subscription.id} with status: #{response[:status]}")
    end
  end

  def schedule_partial_rebill(remaining_balance)
    @logger.info("Scheduling partial rebill of #{remaining_balance} for subscription #{@subscription.id} in one week.")
    PartialRebillWorker.perform_in(7 * 24 * 60 * 60, @subscription.id, remaining_balance)
  end
end

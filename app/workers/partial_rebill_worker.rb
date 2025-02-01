# frozen_string_literal: true

require 'sidekiq'
require_relative '../services/rebill_service'
require_relative '../models/subscription'

# Class is responsible for background scheduled job
class PartialRebillWorker
  include Sidekiq::Worker

  def perform(subscription_id, amount)
    subscription = Subscription.new(subscription_id, amount)
    rebill_service = RebillService.new(subscription)
    rebill_service.call
  end
end

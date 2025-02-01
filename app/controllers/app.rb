# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'dotenv/load'
require_relative '../models/subscription'
require_relative '../services/rebill_service'

post '/rebill' do
  content_type :json

  request_body = JSON.parse(request.body.read)
  subscription_id = request_body['subscription_id']
  amount = request_body['amount']

  subscription = Subscription.new(subscription_id, amount)
  rebill_service = RebillService.new(subscription)
  rebill_service.call

  { message: 'Rebill process initiated' }.to_json
end

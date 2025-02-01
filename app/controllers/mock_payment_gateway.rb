# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'dotenv/load'

post '/paymentIntents/create' do
  content_type :json

  request_body = JSON.parse(request.body.read)
  amount = request_body['amount']
  subscription_id = request_body['subscription_id']

  if amount.nil? || subscription_id.nil?
    status 400
    return { status: 'failed' }.to_json
  end

  case rand(3)
  when 0 then status 200, { status: 'success' }.to_json
  when 1 then status 200, { status: 'insufficient_funds' }.to_json
  else status 400, { status: 'failed' }.to_json
  end
end

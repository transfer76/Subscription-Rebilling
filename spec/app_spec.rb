# frozen_string_literal: true

require 'rack/test'
require 'json'
require_relative '../app/controllers/app' # Load the Sinatra app

RSpec.describe 'Subscription Rebilling App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'POST /rebill' do
    let(:subscription) { Subscription.new('sub_12345', 1000) }

    context 'with valid input' do
      it 'initiates the rebill process and returns a success message' do
        allow(Requests::PaymentService).to receive(:call).and_return({ status: 'success' })

        post '/rebill', { subscription_id: 'sub_12345', amount: 1000 }.to_json, { 'CONTENT_TYPE' => 'application/json' }

        expect(last_response.status).to eq(200)
        response_body = JSON.parse(last_response.body)
        expect(response_body['message']).to eq('Rebill process initiated')
      end

      it 'initiates rebilling process for valid input' do
        allow_any_instance_of(RebillService).to receive(:call).and_return(nil)

        post '/rebill', { subscription_id: 'sub_123', amount: 100.0 }.to_json, { 'CONTENT_TYPE' => 'application/json' }
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)['message']).to eq('Rebill process initiated.')
      end
    end

    context 'with missing fields' do
      it 'returns a 400 error with a validation message' do
        post '/rebill', { subscription_id: 'sub_12345' }.to_json, { 'CONTENT_TYPE' => 'application/json' }

        expect(last_response.status).to eq(400)
        response_body = JSON.parse(last_response.body)
        expect(response_body['error']).to include('Missing required fields')
      end
    end

    context 'when payment fails' do
      it 'logs the failure and returns a success message (since the rebill process is initiated)' do
        allow(Requests::PaymentService).to receive(:new).and_return({ status: 'failed' })

        post '/rebill', { subscription_id: 'sub_12345', amount: 1000 }.to_json, { 'CONTENT_TYPE' => 'application/json' }

        expect(last_response.status).to eq(200)
        response_body = JSON.parse(last_response.body)
        expect(response_body['message']).to eq('Rebill process initiated')
      end
    end
  end
end

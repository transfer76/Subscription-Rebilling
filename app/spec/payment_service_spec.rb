# frozen_string_literal: true

require_relative '../services/requests/payment_service'
require 'rspec'

RSpec.describe Requests::PaymentService do
  let(:subscription_id) { 'sub_12345' }
  let(:gateway) { described_class.new(params: { amount: 100, subscription_id: subscription_id }) }

  describe '.call' do
    it 'returns success status' do
      allow_any_instance_of(Faraday::Connection).to receive(:post).and_return(
        double(status: 200, body: { status: 'success' }.to_json)
      )

      response = gateway.call
      expect(response['status']).to eq('success')
    end

    it 'returns insufficient_funds status when fails due to low ballance' do
      allow_any_instance_of(Faraday::Connection).to receive(:post).and_return(
        double(status: 200, body: { status: 'insufficient_funds' }.to_json)
      )

      response = gateway.call
      expect(response['status']).to eq('insufficient_funds')
    end

    it 'returns failed status when API request fails' do
      allow_any_instance_of(Faraday::Connection).to receive(:post).and_return(
        double(status: 500, body: { status: 'failed' }.to_json)
      )

      response = gateway.call
      expect(response['status']).to eq('failed')
    end
  end
end

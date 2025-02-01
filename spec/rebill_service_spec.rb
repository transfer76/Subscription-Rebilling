# frozen_string_literal: true

require_relative '../app/services/requests/payment_service'
require_relative '../app/services/rebill_service'
require_relative '../app/models/subscription'
require_relative '../app/workers/partial_rebill_worker'
require 'rspec'

class FakeLogger
  def info(message); end
  def warn(message); end
  def error(message); end
end

RSpec.describe RebillService do
  let(:subscription) { Subscription.new('sub_12345', 1000) }
  let(:logger) { FakeLogger.new }
  let(:rebill) { RebillService.new(subscription:) }
  let(:payment_gateway) { instance_double('PaymentGateway') }

  before do
    allow(Requests::PaymentService).to receive(:new).and_return(payment_gateway)
  end

  it 'processes full payment successfully' do
    allow(payment_gateway).to receive(:call).and_return({ status: 'success' })

    expect(logger).to receive(:info).with(/Payment succeeded/)
    rebill.call
  end

  it 'processes partial payments on insufficient funds' do
    allow(payment_gateway).to receive(:call).and_return({ status: 'insufficient_funds' })

    expect(logger).to receive(:warn).at_least(:once).with(/Insufficient funds/)
    rebill.call
  end

  describe '#rebill' do
    context 'when payment is successful on first attempt' do
      it 'charges the full amount' do
        allow(payment_gateway).to receive(:call).and_return({ status: 'success' })
        rebill_service = RebillService.new(subscription:)
        rebill_service.call

        expect(payment_gateway).to have_received(:call)
      end
    end

    context 'when payment fails and retries with lower amounts' do
      it 'retries with 75%, 50%, and 25% of the amount' do
        allow(payment_gateway).to receive(:call)
          .and_return(
            { status: 'insufficient_funds' },
            { status: 'success' }
          )

        rebill.call

        expect(Requests::PaymentService).to have_received(:call).with(750, 'sub_12345')
        expect(Requests::PaymentService).to have_received(:call).with(500, 'sub_12345')
      end
    end
  end
end

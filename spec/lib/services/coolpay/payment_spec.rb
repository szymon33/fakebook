# frozen_string_literal: true

require 'services/coolpay/payment'

describe CoolpayService::Payment do
  let(:client) { described_class.new }

  context '.list' do
    subject { client.list }

    it 'calls get with payments url' do
      expect(described_class).to receive(:get).with('/payments', {})
      subject
    end
  end
end

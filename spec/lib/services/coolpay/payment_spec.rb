# frozen_string_literal: true

require 'services/coolpay/payment'

describe CoolpayService::Payment do
  let(:client) { described_class.new }

  context '.list', vcr: { cassette_name: 'payments_list',
                          allow_playback_repeats: true } do
    subject { client.list }

    it { is_expected.to be_a Array }
    it { is_expected.to_not be_empty }

    it 'calls get with payments url', vcr: false do
      allow(client).to receive(:puts) # don't blur the output
      expect(described_class).to receive(:get).with('/payments', anything)
      subject
    end
  end
end

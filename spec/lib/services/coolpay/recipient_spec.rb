# frozen_string_literal: true

require 'services/coolpay/recipient'

describe CoolpayService::Recipient do
  let(:client) { described_class.new }

  context '.list', vcr: { cassette_name: 'recipients_list',
                          allow_playback_repeats: true } do
    subject { client.list }

    it { is_expected.to be_a Array }
    it { is_expected.to_not be_empty }

    it "calls 'get' with payments url", vcr: false do
      allow(client).to receive(:puts) # don't blur the output
      allow(client).to receive(:headers_token)

      expect(described_class).to receive(:get).with('/recipients', anything)
      subject
    end
  end
end

# frozen_string_literal: true

require 'services/coolpay/recipient'

describe CoolpayService::Recipient do
  let(:client) { described_class.new }

  context '.list', vcr: { cassette_name: 'recipients_list',
                          allow_playback_repeats: true } do
    subject { client.list }

    it { is_expected.to be_a Array }
    it { is_expected.to_not be_empty }

    it "calls 'get' with recipients url", vcr: false do
      allow(client).to receive(:puts) # don't blur the output
      allow(client).to receive(:headers_token)

      expect(described_class).to receive(:get).with('/recipients', anything)
      subject
    end
  end

  context '.create', vcr: { cassette_name: 'recipients_create',
                            allow_playback_repeats: true } do
    subject { client.create(recipient: valid_attrs) }

    let(:valid_attrs) do
      {
        name: 'James Bond'
      }
    end

    it { is_expected.to be_a Hash }
    it { is_expected.to_not be_empty }

    it "calls 'post' with recipients url", vcr: false do
      allow(client).to receive(:puts) # don't blur the output
      allow(client).to receive(:headers_token)

      expect(described_class).to receive(:post).with('/recipients', anything)
      subject
    end
  end
end

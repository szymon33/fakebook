# frozen_string_literal: true

require 'services/coolpay/payment'

describe CoolpayService::Payment do
  let(:payments) { described_class.new }

  context '.list', vcr: { cassette_name: 'payments_list',
                          allow_playback_repeats: true } do
    subject { payments.list }

    it { is_expected.to be_a Array }
    it { is_expected.to_not be_empty }

    it "calls 'get' with payments url", vcr: false do
      allow(payments).to receive(:puts) # don't blur the output
      allow(payments).to receive(:headers_token)

      expect(described_class).to receive(:get).with('/payments', anything)
      subject
    end

    it 'carries on with existing token' do
      token = CoolpayService::Client.new.bearer_token
      payments = described_class.new(token)
      expect(payments.list).to be_a Array
    end
  end

  context '.create', vcr: { cassette_name: 'payments_create',
                            allow_playback_repeats: true } do
    subject { payments.create(payment: valid_attrs) }

    let(:valid_attrs) do
      {
        amount: 123.45,
        currency: 'GBP',
        recipient_id: '58adc45c-5eac-42a6-a55b-4becfb22a189'
      }
    end

    it { is_expected.to be_a Hash }
    it { is_expected.to_not be_empty }

    it "calls 'post' with payments url", vcr: false do
      allow(payments).to receive(:puts) # don't blur the output
      allow(payments).to receive(:headers_token)

      expect(described_class).to receive(:post).with('/payments', anything)
      subject
    end
  end
end

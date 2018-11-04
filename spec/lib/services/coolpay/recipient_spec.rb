# frozen_string_literal: true

require 'services/coolpay/recipient'

describe CoolpayService::Recipient do
  let(:recipients) { described_class.new }

  context '.list', vcr: { cassette_name: 'recipients_list',
                          allow_playback_repeats: true } do
    subject { recipients.list }

    VCR.use_cassette('recipients_list') do
      it { is_expected.to be_a Array }
      it { is_expected.to_not be_empty }
    end

    it "calls 'get' with recipients url", vcr: false do
      allow(recipients).to receive(:puts) # don't blur the output
      allow(recipients).to receive(:headers_token)

      expect(described_class).to receive(:get).with('/recipients', anything)
      subject
    end

    it 'carries on with existing token' do
      token = CoolpayService::Client.new.bearer_token
      recipients = described_class.new(token)
      expect(recipients.list).to be_a Array
    end
  end

  context '.create', vcr: { cassette_name: 'recipients_create',
                            allow_playback_repeats: true } do
    subject { recipients.create(recipient: valid_attrs) }

    let(:valid_attrs) do
      {
        name: 'James Bond'
      }
    end

    it { is_expected.to be_a Hash }
    it { is_expected.to_not be_empty }

    it "calls 'post' with recipients url", vcr: false do
      allow(recipients).to receive(:puts) # don't blur the output
      allow(recipients).to receive(:headers_token)

      expect(described_class).to receive(:post).with('/recipients', anything)
      subject
    end
  end

  describe 'search recipients list', vcr: { cassette_name: 'search_reipients_list',
                                            allow_playback_repeats: true } do
    subject { recipients.list('James Bond') }

    VCR.use_cassette('search_reipients_list') do
      it { is_expected.to be_a Array }
      it { is_expected.to_not be_empty }
    end

    describe 'JSON response' do
      subject { recipients.list('James Bond').first }

      it { is_expected.to include(name: 'James Bond') }
      it { is_expected.to include(id: a_kind_of(String)) }
    end
  end
end

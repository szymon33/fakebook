# frozen_string_literal: true

require 'services/coolpay/client'

describe CoolpayService::Client do
  subject { described_class }
  let(:client) { described_class.new }

  it { respond_to(:get) }

  context '.bearer_token', vcr: { cassette_name: 'login' } do
    subject { client.send(:bearer_token) }

    it "call POST action with '/login' url" do
      allow(client).to receive(:puts) # don't blur the output
      expect(described_class).to receive(:post).with('/login', anything)
      subject
    end

    it { is_expected.to be_a String }
    it { is_expected.to_not be_empty }
  end

  context '.on_screen' do
    it 'calls puts' do
      expect(client).to receive(:puts)
      client.send(:on_screen, 'La La Land')
    end
  end
end

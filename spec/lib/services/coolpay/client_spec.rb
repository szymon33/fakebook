# frozen_string_literal: true

require 'services/coolpay/client'

describe CoolpayService::Client do
  subject { described_class }
  let(:client) { described_class.new }

  it { respond_to(:get) }

  context '.on_screen' do
    it 'calls puts' do
      expect(client).to receive(:puts)
      client.send(:on_screen, 'La La Land')
    end
  end
end

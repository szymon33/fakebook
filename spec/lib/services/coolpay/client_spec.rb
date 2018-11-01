# frozen_string_literal: true

require 'services/coolpay/client'

describe CoolpayService::Client do
  subject { described_class }

  it { respond_to(:get) }
end

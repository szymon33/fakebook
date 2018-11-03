# frozen_string_literal: true

require 'ui'

describe Ui do
  describe 'when initialized' do
    it 'has coolpay client assigned' do
      coolpay = subject.instance_variable_get('@coolpay')
      expect(coolpay).to be_a CoolpayService::Client
    end
  end
end

# frozen_string_literal: true

require 'ui'

describe Ui do
  describe 'when initialized' do
    it 'has coolpay token assigned' do
      allow_any_instance_of(CoolpayService::Client)
        .to receive(:bearer_token)
        .and_return('La La Land')
      coolpay = subject.instance_variable_get('@token')
      expect(coolpay).to eq 'La La Land'
    end
  end
end

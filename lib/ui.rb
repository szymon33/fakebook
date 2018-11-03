# frozen_string_literal: true

require_relative 'services/coolpay/client'

class Ui
  def initialize
    @coolpay = CoolpayService::Client.new
  end

  def build; end
end

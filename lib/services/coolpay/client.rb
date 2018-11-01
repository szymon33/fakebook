# frozen_string_literal: true

require 'httparty'

module CoolpayService
  class Client
    include HTTParty

    base_uri 'https://coolpay.herokuapp.com/api'

    def initialize
      @options = {}
    end
  end
end

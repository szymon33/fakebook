# frozen_string_literal: true

require 'httparty'

module CoolpayService
  class Client
    include HTTParty

    base_uri 'https://coolpay.herokuapp.com/api'

    def initialize
      @options = {}
    end

    protected

    def json_body
      JSON.parse(response.body, symbolize_names: true)
    end

    def handle_error(response)
      on_screen('Problem with connection') && return if response.nil?
      on_screen("Unexpected error #{response.code}") if response.code
    end

    def on_screen(txt)
      puts txt
    end
  end
end

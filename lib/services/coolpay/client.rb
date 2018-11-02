# frozen_string_literal: true

require 'httparty'

module CoolpayService
  class Client
    BASE_URI = 'https://coolpay.herokuapp.com/api'
    USERNAME = ENV['COOLPAY_USERNAME']
    APIKEY = ENV['COOLPAY_APIKEY']

    include HTTParty

    base_uri BASE_URI

    def initialize
      @options = {
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        }
      }
      @bearer_token = nil
    end

    protected

    def json_body(resp)
      JSON.parse(resp.body, symbolize_names: true)
    end

    def handle_error(resp)
      if resp
        on_screen("Unexpected error #{resp.code}")
      else
        on_screen('Problem with connection to coolpay API')
      end
      nil
    end

    def on_screen(txt)
      puts txt
      nil
    end

    def bearer_token
      @bearer_token ||= begin
                          begin
                            response = login
                          rescue StandardError
                            on_screen('Unexpected standard error')
                          end
                          response&.success? ? json_body(response).fetch(:token) : handle_error(response)
                        end
    end

    def options_with_token
      @options[:headers]['Authorization'] = "Bearer #{bearer_token}"
      @options
    end

    def login
      self.class.post('/login', body: {
        username: USERNAME,
        apikey: APIKEY
      }.to_json)
    end
  end
end

# frozen_string_literal: true

require 'httparty'

module CoolpayService
  class Client
    BASE_URI = 'https://coolpay.herokuapp.com/api'
    USERNAME = ENV['COOLPAY_USERNAME']
    APIKEY = ENV['COOLPAY_APIKEY']

    include HTTParty

    base_uri BASE_URI

    headers 'Content-Type' => 'application/json'
    headers 'Accept' => 'application/json'

    def initialize
      @options = {}
      @bearer_token = nil
    end

    def bearer_token
      @bearer_token ||= begin
                          begin
                            resp = login
                          rescue StandardError
                            on_screen('Unexpected standard error')
                          end
                          resp&.success? ? json_body(resp).fetch(:token) : handle_error(resp)
                        end
    end

    protected

    def json_body(resp)
      JSON.parse(resp.body, symbolize_names: true)
    end

    def handle_error(resp)
      if resp
        if resp.code == 422 && resp['errors']
          puts "API Coolpay validation errors #{resp['errors']}"
        else
          on_screen("API Coolpay Server unexpected error #{resp.code}")
        end
      else
        on_screen('Problem with connection to coolpay API')
      end
      nil
    end

    def on_screen(txt)
      puts txt
      nil
    end

    def headers_token
      { 'Authorization' => "Bearer #{bearer_token}" }
    end

    def login
      self.class.post('/login', body: {
        username: USERNAME,
        apikey: APIKEY
      }.to_json)
    end
  end
end

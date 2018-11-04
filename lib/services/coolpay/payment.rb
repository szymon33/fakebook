# frozen_string_literal: true

require_relative 'client'

module CoolpayService
  class Payment < Client
    def initialize(bearer_token = nil)
      @bearer_token = bearer_token
      @url = '/payments'
    end

    def list
      begin
        resp = self.class.get(@url, headers: headers_token)
      rescue StandardError
        on_screen('Unexpected standard error')
      end
      resp&.success? ? json_body(resp).fetch(:payments) : handle_error(resp)
    end

    def create(payment)
      begin
        resp = self.class.post(@url,
                               headers: headers_token, body: payment.to_json)
      rescue StandardError
        on_screen('Unexpected standard error')
      end
      resp&.success? ? json_body(resp).fetch(:payment) : handle_error(resp)
    end
  end
end

# frozen_string_literal: true

require_relative 'client'

module CoolpayService
  class Recipient < Client
    def initialize
      @url = '/recipients'
    end

    def list(name = nil)
      begin
        query = name.nil? ? nil : { name: name }
        resp = self.class.get(@url,
                              headers: headers_token, query: query)
      rescue StandardError
        on_screen('Unexpected standard error')
      end
      resp&.success? ? json_body(resp).fetch(:recipients) : handle_error(resp)
    end

    def create(recipient)
      begin
        resp = self.class.post(@url, headers: headers_token,
                                     ody: recipient.to_json)
      rescue StandardError
        on_screen('Unexpected standard error')
      end
      resp&.success? ? json_body(resp).fetch(:recipient) : handle_error(resp)
    end
  end
end

# frozen_string_literal: true

require_relative 'client'

module CoolpayService
  class Recipient < Client
    def initialize
      @url = '/recipients'
    end

    def list
      begin
        resp = self.class.get(@url, headers: headers_token)
      rescue StandardError
        on_screen('Unexpected standard error')
      end
      resp&.success? ? json_body(resp).fetch(:recipients) : handle_error(resp)
    end
  end
end

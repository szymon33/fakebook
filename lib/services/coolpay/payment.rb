# frozen_string_literal: true

require_relative 'client'

module CoolpayService
  class Payment < Client
    def list
      url = '/payments'
      begin
        resp = self.class.get(url, options_with_token)
      rescue StandardError
        on_screen('Unexpected standard error')
      end
      resp&.success? ? json_body(resp).fetch(:payments) : handle_error(resp)
    end
  end
end

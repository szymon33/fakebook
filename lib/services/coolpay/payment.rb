# frozen_string_literal: true

require_relative 'client'

module CoolpayService
  class Payment < Client
    def list
      url = '/payments'
      begin
        response = self.class.get(url, @options)
      rescue StandardError
        on_screen('Unexpected standard error')
      end
      response&.success? ? json_body[:payments] : handle_error(response)
    end
  end
end

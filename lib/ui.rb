# frozen_string_literal: true

require 'highline/import'
require_relative 'services/coolpay/client'
require_relative 'services/coolpay/payment'
require_relative 'services/coolpay/recipient'

TBL_PAYMENTS_LAYOUT = {
  status: 6,
  recipient_id: 38,
  id: 38,
  currency: 10,
  amount: 12
}.freeze
BACK_TO_PREVIOUS_STR = 'Back to the previous menu'

class Ui
  def initialize
    @token = CoolpayService::Client.new.bearer_token
    @last_recipient = {}
    @last_payment = {}
  end

  def build
    return unless @token # continue only when Coolpay API is available

    loop do
      title('Main Menu')
      chosen = choose do |menu|
        menu.prompt = 'Please choose?  '
        menu.choice('Add recipient') { add_recipient }
        menu.choice('Send money') { send_money }
        menu.choice('Check all payments') { check_payments }
        menu.choice('Exit program')
      end
      break if chosen == 'Exit program'
    end
    say('Bye!')
  end

  private

  #
  # Add recipient
  #

  def add_recipient
    name = recipient_form
    return unless name

    recipients = CoolpayService::Recipient.new(@token)
    @last_recipient = recipients.create(recipient: { name: name })
    say("Recipient '#{name}' created successfully!") if @last_recipient
    STDIN.getch
  end

  def recipient_form
    title('Add Recipient')
    name = ask('Name?  ', String) do |q|
      q.validate = ->(p) { p.length > 2 }
      q.responses[:not_valid] = 'Enter valid name'
    end
    answer = agree('Are you sure to create the recipient? ', true)
    answer ? name : nil
  end

  #
  # Send money
  #

  def send_money
    loop do
      @last_recipient = find_recipient || {}
      break if @last_recipient.empty?

      attrs = payment_form(@last_recipient)
      create_payment(payment: attrs) && break if attrs
    end
  end

  def find_recipient
    title('Send money: Step 1 - Find recipient')
    list = CoolpayService::Recipient.new(@token).list
    menu_items = list.map { |elem| elem[:name] }
    menu_items << BACK_TO_PREVIOUS_STR
    if list.any?
      chosen = choose do |menu|
        menu.prompt = 'Please choose recipient?  '
        menu.default = @last_recipient[:name] || BACK_TO_PREVIOUS_STR
        menu_items.each { |i| menu.choice(i) }
      end
      chosen == BACK_TO_PREVIOUS_STR ? nil : list.select { |e| e[:name] == chosen }.first
    else
      clear
      say('Recipients list is empty')
      STDIN.getch
      nil
    end
  end

  def payment_form(recipient)
    return unless recipient

    result = { recipient_id: recipient[:recipient_id] }
    title("Send money: Step 2 - Payment details for #{recipient[:name]}")
    result[:amount] = ask('Amount?  ', Float) do |q|
      q.validate = ->(p) { p.to_f.positive? }
      q.responses[:not_valid] = 'Enter valid amount'
    end
    result[:currency] = ask('Currency? ', String) do |q|
      q.validate = ->(p) { p.length == 3 }
      q.default = 'GBP'
      q.responses[:not_valid] = 'Enter valid currency e.q. GBP'
    end
    answer = agree('Are you sure to send money? ', true)
    answer ? result : nil
  end

  def create_payment(attrs)
    @last_payment = nil
    payments = CoolpayService::Payment.new(@token)
    @last_payment = payments.create(attrs)
    if @last_payment
      say("#{@last_payment[:amount]} #{@last_payment[:currency]} sent successfully!")
    end
    STDIN.getch
  end

  #
  # Check payments
  #

  def check_payments
    title('Check all payments')
    list = CoolpayService::Payment.new(@token).list
    print_collection(list, TBL_PAYMENTS_LAYOUT)
    STDIN.getch
  end

  #
  # Helper methods
  #

  def title(txt)
    clear
    say("\n[#{txt}]")
    say("Coolpay Token: #{@token[0..6]}...\n\n")
  end

  def clear
    system('clear') || system('cls')
  end

  def print_collection(list, layout)
    if list.empty?
      say('There are no records to be shown')
    else
      first_row = []
      layout.each { |k, v| first_row << k.to_s.rjust(v) }
      puts first_row.join

      puts (list.map do |row|
        temp = []
        row.each do |key, value|
          (temp << value.to_s.rjust(layout[key])) if layout[key]
        end
        temp.join
      end)
    end
  end
end

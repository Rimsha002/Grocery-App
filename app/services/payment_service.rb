class PaymentService
  class PaymentError < StandardError; end

  def self.process_payment(order, payment_params)
    new(order, payment_params).process
  end

  def initialize(order, payment_params)
    @order = order
    @payment_params = payment_params
  end

  def process
    # Validate payment parameters
    validate_payment_params!

    # Simulate payment processing delay
    sleep(rand(1..2))

    # Simulate payment success/failure (90% success rate)
    if rand(1..100) <= 90
      process_successful_payment
    else
      process_failed_payment
    end
  end

  private

  def validate_payment_params!
    unless valid_card_number?(@payment_params[:card_number])
      raise PaymentError, "Invalid card number"
    end

    unless valid_expiry_date?(@payment_params[:expiry_month], @payment_params[:expiry_year])
      raise PaymentError, "Invalid expiry date"
    end

    unless valid_cvv?(@payment_params[:cvv])
      raise PaymentError, "Invalid CVV"
    end
  end

  def process_successful_payment
    ActiveRecord::Base.transaction do
      # Create payment record
      payment = @order.create_payment!(
        amount: @order.total,
        payment_method: "credit_card",
        status: "completed",
        card_last4: @payment_params[:card_number][-4..-1],
        transaction_id: generate_transaction_id
      )

      # Update order status
      @order.update!(
        status: "processing",
        paid_at: Time.current
      )

      # Send confirmation email
      OrderMailer.confirmation(@order).deliver_later

      # Return success response
      {
        success: true,
        payment: payment,
        message: "Payment processed successfully"
      }
    end
  end

  def process_failed_payment
    error_message = ["Insufficient funds", "Card declined", "Network error"].sample
    raise PaymentError, error_message
  end

  def valid_card_number?(number)
    return false unless number.present?
    number = number.to_s.gsub(/\D/, '')
    return false unless number.length.between?(13, 19)
    
    # Luhn algorithm for card number validation
    sum = 0
    num_digits = number.length
    odd_even = num_digits & 1

    number.each_char.with_index do |digit, index|
      digit = digit.to_i
      if ((index + 1) & 1) ^ odd_even == 0
        digit *= 2
        digit -= 9 if digit > 9
      end
      sum += digit
    end

    (sum % 10) == 0
  end

  def valid_expiry_date?(month, year)
    return false unless month.present? && year.present?
    
    month = month.to_i
    year = year.to_i
    current_year = Time.current.year
    current_month = Time.current.month

    return false unless month.between?(1, 12) && year >= current_year
    return true if year > current_year
    month >= current_month
  end

  def valid_cvv?(cvv)
    return false unless cvv.present?
    cvv = cvv.to_s.gsub(/\D/, '')
    cvv.length.between?(3, 4)
  end

  def generate_transaction_id
    "txn_#{SecureRandom.hex(10)}"
  end
end 
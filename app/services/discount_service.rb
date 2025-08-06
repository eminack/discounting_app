require 'bigdecimal'

class DiscountService
  def initialize(brand_discounts: {}, category_discounts: {}, voucher_config: {}, bank_offers: {})
    @strategies = [
      BrandDiscountStrategy.new(brand_discounts),
      CategoryDiscountStrategy.new(category_discounts),
      VoucherDiscountStrategy.new(voucher_config),
      BankOfferStrategy.new(bank_offers)
    ]
    @voucher_config = voucher_config
  end

  # Calculate final price after applying discount logic:
  # 1. Apply brand/category discounts
  # 2. Apply voucher discounts
  # 3. Apply bank offers
  #
  # Returns a DiscountedPrice object with:
  # - original total price
  # - final total price
  # - applied discounts (hash: discount_name => amount)
  # - descriptive message
  def calculate_cart_discounts(cart_items, customer, payment_info = nil)
    return nil if cart_items.empty?

    original_price = calculate_original_total(cart_items)
    current_price = original_price
    applied_discounts = {}
    messages = []

    @strategies.each do |strategy|
      next unless strategy.applicable?(cart_items, customer, payment_info)

      result = strategy.apply(cart_items, customer, payment_info)
      applied_discounts[result[:discount_name]] = result[:discount_amount]
      current_price = result[:updated_cart_price]
      messages << generate_discount_message(result)
    end

    DiscountedPrice.new(
      original_price: original_price,
      final_price: current_price,
      applied_discounts: applied_discounts,
      messages: messages
    )
  end

  # Validate discount code for eligibility:
  # - Check brand exclusions
  # - Check category restrictions
  # - Check customer tier requirements
  # Returns true/false or raises descriptive validation errors
  def validate_discount_code(code, cart_items, customer)
    raise ArgumentError, 'Invalid discount code' unless @voucher_config.key?(code)

    config = @voucher_config[code]
    cart_total = calculate_original_total(cart_items)

    if cart_total < config[:min_cart_value]
      raise ArgumentError, "Cart value must be at least #{config[:min_cart_value]} for this code"
    end

    if config[:required_tier] && customer.tier != config[:required_tier]
      raise ArgumentError, "This code is only valid for #{config[:required_tier]} tier customers"
    end

    if cart_items.all? { |item| config[:excluded_brands].include?(item.product.brand) }
      raise ArgumentError, 'This code is not applicable for the selected brands'
    end

    if cart_items.all? { |item| config[:excluded_categories].include?(item.product.category) }
      raise ArgumentError, 'This code is not applicable for the selected categories'
    end

    true
  end

  private

  def calculate_original_total(cart_items)
    cart_items.sum { |item| item.product.base_price * item.quantity }
  end

  def generate_discount_message(result)
    "Applied #{result[:discount_name]}: -#{format_currency(result[:discount_amount])}"
  end

  def format_currency(amount)
    format('%.2f', amount)
  end
end 
require 'bigdecimal'

module DiscountCalculators
  class VoucherDiscountStrategy
    include DiscountStrategyInterface

    def initialize(voucher_config)
      @voucher_config = voucher_config # Hash of code => {percentage:, min_cart_value:, excluded_brands:, excluded_categories:, required_tier:}
    end

    def applicable?(cart_items, customer, _payment_info = nil)
      return false unless @voucher_config.key?(customer.voucher_code)
      
      config = @voucher_config[customer.voucher_code]
      cart_total = calculate_cart_total(cart_items)
      
      return false if cart_total < config[:min_cart_value]
      return false if config[:required_tier] && customer.tier != config[:required_tier]
      
      cart_items.any? do |item|
        !config[:excluded_brands].include?(item.product.brand) &&
        !config[:excluded_categories].include?(item.product.category)
      end
    end

    def apply(cart_items, customer, _payment_info = nil)
      config = @voucher_config[customer.voucher_code]
      total_discount = BigDecimal('0')
      updated_cart_price = BigDecimal('0')

      cart_items.each do |item|
        item_total = item.product.base_price * item.quantity
        
        if !config[:excluded_brands].include?(item.product.brand) &&
          !config[:excluded_categories].include?(item.product.category)
          item_discount = item_total * (config[:percentage] / 100.0)
          total_discount += format_discount_amount(item_discount)
          updated_cart_price += item_total - item_discount
        else
          updated_cart_price += item_total
        end
      end

      {
        discount_name: "Voucher Discount (#{customer.voucher_code})",
        discount_amount: total_discount,
        updated_cart_price: format_discount_amount(updated_cart_price)
      }
    end
  end 
end
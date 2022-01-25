require_relative 'meta_data'
require_relative '../services/discount_calculator.rb'

class Checkout
  def initialize(cart_items)
    @cart_items = if ARGV.empty?
                    cart_items
                  else
                    ARGV
                  end
  end

  def call
    scanned_items = []
    @cart_items.each do |cart_item|
      scanned_items << DiscountCalculator.new(cart_item: cart_item).call
    end

    puts "\nBill:\n"
    puts "\n----------------------\n"

    scanned_items.each do |item|
      puts "Item - #{item[:item]}"
      puts "Quantity - #{item[:quantity]}"
      puts "Discount - #{item[:discount]}"
      puts "Price - #{item[:total]}"
      puts "\n"
    end
    total = scanned_items.collect {|item| item[:total]}.sum
    puts "----------------------\n"
    puts "\nTotal: #{total}"
    puts "\n"
    total
  end
end

Checkout.new([{item: :apple, quantity: 3, discount: 'HALF_PRICE_FOR_EVEN'},
              {item: :banana, quantity: 5, discount: 'HALF_PRICE_FOR_ALL'},
              {item: :pear, quantity: 2, discount: 'HALF_PRICE_FOR_EVEN'},
              {item: :mango, quantity: 3, discount: 'BUY_THREE_GET_ONE'},
              {item: :pineapple, quantity: 4, discount: 'HALF_PRICE_FOR_ONE'}]).call


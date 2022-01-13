require 'pry'
require_relative 'meta_data'

class Checkout
  def initialize(cart_items)
    @cart_items = cart_items
  end

  def checkout
    puts "Total-#{total}"
  end

  private

  def total
    total = 0.0
    @cart_items.each do |cart_item|
      case cart_item[0]
      when :apple, :pear
        total += buy_even_at_half_price(cart_item)
      when :banana
        total += buy_all_at_half_price(cart_item)
      when :pineapple
        total += buy_1_at_half_price(cart_item)
      else
        total += price_of(cart_item) * cart_item[1]
      end
    end
    total
  end

  def price_of(cart_item)
    MetaData::ITEMS.select do |item|
      item[:name].eql?(cart_item[0].to_s)
    end.first[:price]
  end

  def buy_even_at_half_price(cart_item)
    count = cart_item[1]
    return price_of(cart_item) * (count / 2) if (count % 2 == 0)

    price_of(cart_item) * count
  end

  def buy_1_at_half_price(cart_item)
    half_price = price_of(cart_item) / 2
    (price_of(cart_item) * (cart_item[1] - 1)) + half_price
  end

  def buy_all_at_half_price(cart_item)
    (price_of(cart_item) / 2) * cart_item[1]
  end
end

Checkout.new({'apple': 3, 'pineapple': 4, 'banana': 5, 'pear': 2, 'mango': 3}).checkout

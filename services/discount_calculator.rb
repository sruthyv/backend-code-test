class DiscountCalculator
  def initialize(cart_item:)
    @price = ::MetaData::PRICING_RULES.fetch(cart_item[:item])
    @quantity = cart_item[:quantity]
    @cart_item = cart_item[:item]
    @discount = cart_item[:discount]
    @cart_item_hash = cart_item
  end
  
  def call
    case @discount
    when 'HALF_PRICE_FOR_EVEN'
      scan_price(buy_even_at_half_price)
    when 'HALF_PRICE_FOR_ALL'
      scan_price(buy_all_at_half_price)
    when 'HALF_PRICE_FOR_ONE'
      scan_price(buy_1_at_half_price)
    when 'BUY_THREE_GET_ONE'
      scan_price(buy_three_get_one)
    else
      scan_price(@price * @quantity)
    end
  end

  private

  def buy_even_at_half_price
    return 0.0 unless ( @cart_item == :apple || @cart_item == :pear )
    return @price * @quantity unless (@quantity % 2 == 0)

    @price * (@quantity / 2)
  end

  def buy_all_at_half_price
    return 0.0 unless @cart_item == :banana

    (@price / 2) * @quantity
  end

  def buy_1_at_half_price
    return 0.0 unless @cart_item == :pineapple

    (@price * (@quantity - 1)) + (@price / 2)
  end

  def buy_three_get_one
    return 0.0 unless @cart_item == :mango

    @cart_item_hash[:quantity] = ((@quantity / 3) + @quantity) # Increare Item quantity
    @price * ( @quantity - (@quantity / 3))
  end

  def scan_price(total)
    @cart_item_hash.merge(total: total)
  end
end

class DiscountCalculator
  def initialize(cart_item:)
    @price = ::MetaData::PRICING_RULES.fetch(cart_item[:item])
    @quantity = cart_item[:quantity]
    @item_name = cart_item[:item]
    @discount = cart_item[:discount]
    @cart_item = cart_item
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
    return 0.0 unless ( @item_name == :apple || @item_name == :pear )
    return @price * @quantity unless (@quantity % 2 == 0)

    @price * (@quantity / 2)
  end

  def buy_all_at_half_price
    return 0.0 unless @item_name == :banana

    (@price / 2) * @quantity
  end

  def buy_1_at_half_price
    return 0.0 unless @item_name == :pineapple

    (@price * (@quantity - 1)) + (@price / 2)
  end

  def buy_three_get_one
    return 0.0 unless @item_name == :mango

    @cart_item[:quantity] = ((@quantity / 3) + @quantity) # Increare Item quantity
    @price * ( @quantity - (@quantity / 3))
  end

  def scan_price(total)
    @cart_item.merge(total: total)
  end
end

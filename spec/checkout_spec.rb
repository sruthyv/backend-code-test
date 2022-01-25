require 'spec_helper'
require 'checkout'

RSpec.describe Checkout do
  describe '#total' do
    subject(:total) { checkout.call }

    context 'when some fruits have dynamic discounts applied' do
      let(:checkout) { Checkout.new([{item: :apple, quantity: 3, discount: 'HALF_PRICE_FOR_EVEN'},
                                    {item: :banana, quantity: 5, discount: 'HALF_PRICE_FOR_ALL'},
                                    {item: :pear, quantity: 2, discount: 'HALF_PRICE_FOR_EVEN'},
                                    {item: :mango, quantity: 3, discount: 'BUY_THREE_GET_ONE'},
                                    {item: :pineapple, quantity: 4, discount: 'HALF_PRICE_FOR_ONE'}]) }
      
      it 'returns the price after discount is applied' do
        expect(total).to eq(35.5)
      end
    end

    context 'when quantity of apple is even' do
      let(:checkout) { Checkout.new([{item: :apple, quantity: 4, discount: 'HALF_PRICE_FOR_EVEN'}]) }

      it 'returns the price of half quantity' do
        expect(total).to eq(2)
      end
    end

    context 'when quantity of apple is not even' do
      let(:checkout) { Checkout.new([{item: :apple, quantity: 3}]) }

      it 'returns the price of full quantity' do
        expect(total).to eq(3)
      end
    end

    context 'when quantity of pear is even' do
      let(:checkout) { Checkout.new([{item: :pear, quantity: 4, discount: 'HALF_PRICE_FOR_EVEN'}]) }

      it 'returns the price of half quantity' do
        expect(total).to eq(4)
      end
    end

    context 'when quantity of pear is not even' do
      let(:checkout) { Checkout.new([{item: :pear, quantity: 3}]) }

      it 'returns the price of full quantity' do
        expect(total).to eq(6)
      end
    end

    context 'when the item is banana' do
      let(:checkout) { Checkout.new([{item: :banana, quantity: 5, discount: 'HALF_PRICE_FOR_ALL'}]) }

      it 'buy all banana at half price' do
        expect(total).to eq(10)
      end
    end

    context 'when the item is pineapple' do
      let(:checkout) { Checkout.new([{item: :pineapple, quantity: 3, discount: 'HALF_PRICE_FOR_ONE'}]) }

      it 'buy one pineapple at half price and all others with full price' do
        expect(total).to eq(7.5)
      end
    end

    context 'when the I buy 3 mangos' do
      let(:checkout) { Checkout.new([{item: :mango, quantity: 3, discount: 'BUY_THREE_GET_ONE'}]) }

      it 'one mango will be free' do
        expect(total).to eq(10)
      end
    end

    context 'when the I buy 2 mangos' do
      let(:checkout) { Checkout.new([{item: :mango, quantity: 2}]) }

      it 'buy all mangos with full price' do
        expect(total).to eq(10)
      end
    end

    context 'when all fruits have no discount applied' do
      let(:checkout) { Checkout.new([{item: :apple, quantity: 3},
                                    {item: :banana, quantity: 5},
                                    {item: :pear, quantity: 2},
                                    {item: :mango, quantity: 3},
                                    {item: :pineapple, quantity: 4}]) }
      
      it 'buy all at full price' do
        expect(total).to eq(54)
      end
    end
  end
end

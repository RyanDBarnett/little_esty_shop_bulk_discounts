require 'rails_helper'

describe Discount do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :percentage_discount }
    it { should validate_presence_of :quantity_threshold }
  end

  describe "relationships" do
    it { should belong_to :merchant }
  end

  describe 'instance methods' do
    describe 'calc_discounted_item_unit_price' do
      it 'applys the discount percentage to a given item unit price' do
        merchant_1 = Merchant.create!(name: 'Hair Care')
        discount_1 = merchant_1.discounts.create!(name: '20% Off 10 Items', percentage_discount: 20.0, quantity_threshold: 10)
        item_1 = merchant_1.items.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, status: 1)

        expected = item_1.unit_price - item_1.unit_price * discount_1.percentage_discount * 0.01
        actual = discount_1.calc_discounted_item_unit_price(item_1.unit_price)

        expect(actual).to eq(expected)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_many(:merchants).through(:item) }
    it { should have_many(:discounts).through(:merchants) }
  end

  describe 'instance methods' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Hair Care')
      @discount_1 = @merchant_1.discounts.create!(name: '20% Off 10 Items', percentage_discount: 20.0, quantity_threshold: 10)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = @merchant_1.invoices.create!(customer_id: @customer_1.id, status: 2,  created_at: "2012-03-27 14:54:09")
      @item_1 = @merchant_1.items.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, status: 1)
      @item_2 = @merchant_1.items.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 20)
      @invoice_item_1 = @invoice_1.invoice_items.create!(item_id: @item_1.id, quantity: 5, unit_price: 10, status: 2, created_at: "2012-03-27 14:54:09")
      @invoice_item_2 = @invoice_1.invoice_items.create!(item_id: @item_2.id, quantity: 5, unit_price: 20, status: 2, created_at: "2012-03-28 14:54:09")
    end

    describe 'find_discount' do
      it 'returns nil if no discounts apply' do
        expect(@invoice_item_1.find_discount).to eq(nil)
      end

      it 'returns a discount if one applys' do
        @invoice_item_1.update!(quantity: 10)

        expect(@invoice_item_1.find_discount).to eq(@discount_1)
      end

      describe 'When two discounts apply' do
        before :each do
          @discount_2 = @merchant_1.discounts.create!(name: '30% Off 15 Items', percentage_discount: 30.0, quantity_threshold: 15)
        end

        it 'returns the best discount' do
          @invoice_item_1.update!(quantity: 12)
          @invoice_item_2.update!(quantity: 15)

          expect(@invoice_item_1.find_discount).to eq(@discount_1)
          expect(@invoice_item_2.find_discount).to eq(@discount_2)
        end
      end
    end

    describe 'apply_discount' do
      it 'does NOT apply discount if invoice item quantity is less than discount quantity threshold' do
        expect(@invoice_item_1.unit_price).to eq(10)
        expect(@invoice_item_2.unit_price).to eq(20)

        @invoice_item_1.apply_discount
        @invoice_item_2.apply_discount

        expect(@invoice_item_1.unit_price).to eq(@invoice_item_1.item.unit_price)
        expect(@invoice_item_2.unit_price).to eq(@invoice_item_2.item.unit_price)
      end

      it 'applies discount when invoice item quantity is greater than discount quantity threshold' do
        @invoice_item_1.update!(quantity: 10)

        @invoice_item_1.apply_discount

        expected_unit_price_1 = @discount_1.calc_discounted_item_unit_price(@item_1.unit_price)

        expected_unit_price_2 = @invoice_item_2.item.unit_price

        expect(@invoice_item_1.unit_price).to eq(expected_unit_price_1)
        expect(@invoice_item_2.unit_price).to eq(expected_unit_price_2)
      end

      describe 'When two discounts apply' do
        before :each do
          @discount_2 = @merchant_1.discounts.create!(name: '30% Off 15 Items', percentage_discount: 30.0, quantity_threshold: 15)
        end

        it 'it applies the discount with the greater percentage discount' do
          @invoice_item_1.update!(quantity: 12)
          @invoice_item_2.update!(quantity: 15)

          @invoice_item_1.apply_discount
          @invoice_item_2.apply_discount

          expect(@invoice_item_1.unit_price).to eq(@discount_1.calc_discounted_item_unit_price(@item_1.unit_price))
          expect(@invoice_item_2.unit_price).to eq(@discount_2.calc_discounted_item_unit_price(@item_2.unit_price))

          @discount_2.update!(name: '15% Off 15 Items', percentage_discount: 15.0, quantity_threshold: 15)

          @invoice_item_1.apply_discount
          @invoice_item_2.apply_discount

          expect(@invoice_item_1.unit_price).to eq(@discount_1.calc_discounted_item_unit_price(@item_1.unit_price))
          expect(@invoice_item_2.unit_price).to eq(@discount_1.calc_discounted_item_unit_price(@item_2.unit_price))
        end

        it "should not apply this merchant's discounts to another merchant's items" do
          @merchant_2 = Merchant.create!(name: 'Merchant 2')
          @invoice_2 = @merchant_2.invoices.create!(customer_id: @customer_1.id, status: 2,  created_at: "2012-03-27 14:54:09")
          @item_3 = @merchant_2.items.create!(name: "Item 3", description: "Item 3 Description", unit_price: 30, status: 1)
          @invoice_item_3 = @invoice_2.invoice_items.create!(item_id: @item_3.id, quantity: 15, unit_price: 30, status: 2, created_at: "2012-03-27 14:54:09")

          @invoice_item_1.update!(quantity: 12)
          @invoice_item_2.update!(quantity: 15)

          @invoice_item_1.apply_discount
          @invoice_item_2.apply_discount
          @invoice_item_3.apply_discount

          expect(@invoice_item_1.unit_price).to eq(@discount_1.calc_discounted_item_unit_price(@item_1.unit_price))
          expect(@invoice_item_2.unit_price).to eq(@discount_2.calc_discounted_item_unit_price(@item_2.unit_price))
          expect(@invoice_item_3.unit_price).to eq(@item_3.unit_price)
        end
      end
    end
  end
end

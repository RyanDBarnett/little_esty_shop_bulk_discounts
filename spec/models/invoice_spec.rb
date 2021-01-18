require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :merchant_id }
    it { should validate_presence_of :customer_id }
  end

  describe "relationships" do
    it { should belong_to :merchant }
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many :transactions}
  end

  describe "instance methods" do
    describe 'total_revenue' do
      before :each do
        @merchant_1 = Merchant.create!(name: 'Hair Care')
        @item_1 = @merchant_1.items.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, status: 1)
        @item_2 = @merchant_1.items.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(merchant_id: @merchant_1.id, customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 10, status: 1)
      end

      it "returns the invoice's total revenue" do
        expect(@invoice_1.total_revenue).to eq(110)
      end

      it "returns a discounted total revenue if a discount applies" do
        @discount_1 = @merchant_1.discounts.create!(name: '20% Off 10 Items', percentage_discount: 20.0, quantity_threshold: 10)

        expect(@invoice_1.total_revenue).to eq(90)
      end
    end
  end
end

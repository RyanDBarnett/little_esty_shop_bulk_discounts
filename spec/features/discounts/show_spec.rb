require 'rails_helper'

describe 'As a merchant' do
  describe 'When I visit my bulk discount show page' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Hair Care')

      @discount_1 = @merchant_1.discounts.create!(name: 'Buy 1 Get 10% Off', percentage_discount: 10.0, quantity_threshold: 1)

      visit merchant_discount_path(@merchant_1.id, @discount_1.id)
    end

    it "I see the bulk discount's quantity threshold and percentage discount" do
      expect(page).to have_content("Percentage Discount: #{@discount_1.percentage_discount}")
      expect(page).to have_content("Quantity Threshold: #{@discount_1.quantity_threshold}")
    end

    it 'I see a link to edit the discount' do
      expect(page).to have_link('Edit Discount', href: edit_merchant_discount_path(@merchant_1.id, @discount_1.id))
    end
  end
end

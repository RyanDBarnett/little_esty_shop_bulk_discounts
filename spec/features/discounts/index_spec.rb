require 'rails_helper'

describe 'As a merchant' do
  describe 'When I visit my discounts index' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Hair Care')

      @discount_1 = @merchant_1.discounts.create!(name: 'Buy 1 Get 10% Off', percentage_discount: 10.0, quantity_threshold: 1)
      @discount_2 = @merchant_1.discounts.create!(name: 'Buy 2 Get 20% Off', percentage_discount: 20.0, quantity_threshold: 2)

      visit merchant_discounts_path(@merchant_1.id)
    end

    it 'I see all of my bulk discounts including their name, percentage discount, and quantity thresholds' do
      discounts = [@discount_1, @discount_2]

      discounts.each do |discount|
        expect(page).to have_content(discount.name)
        expect(page).to have_content("Percentage Discount: #{discount.percentage_discount}")
        expect(page).to have_content("Quantity Threshold: #{discount.quantity_threshold}")
      end
    end

    it "The discount name links to that discount's show page" do
      expect(page).to have_link(@discount_1.name, href: merchant_discount_path(@merchant_1.id, @discount_1.id))
    end
  end
end

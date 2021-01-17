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

    it 'I see a link to create a new discount that takes me to a form to add a new discount' do
      expect(page).to have_link('Create New Discount', href: new_merchant_discount_path(@merchant_1.id))
    end

    it 'next to each bulk discount I see a link to delete it' do
      within "#discount-#{ @discount_1.id }-container" do
        expect(page).to have_link('Delete', href: merchant_discount_path(@merchant_1.id, @discount_1.id))
      end

      within "#discount-#{ @discount_2.id }-container" do
        expect(page).to have_link('Delete', href: merchant_discount_path(@merchant_1.id, @discount_2.id))
      end
    end

    describe "When I click a Discount's Delete link" do
      before :each do
        within "#discount-#{ @discount_2.id }-container" do
          click_link('Delete')
        end
      end

      it 'I am redirected back to the bulk discounts index page' do
        expect(current_path).to eq(merchant_discounts_path(@merchant_1.id))
      end

      it 'I no longer see the discount listed' do
        expect(page).to_not have_content(@discount_2.name)
      end
    end
  end
end

require 'rails_helper'

describe 'As a merchant' do
  describe 'When I visit my new discount form' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Hair Care')

      visit new_merchant_discount_path(@merchant_1.id)
    end

    it "I see a form to add a new bulk discount" do
      expect(page).to have_content("New Merchant Discount Form")
      expect(page).to have_selector("input[id='discount_name']")
      expect(page).to have_selector("input[id='discount_percentage_discount']")
      expect(page).to have_selector("input[id='discount_quantity_threshold']")
    end

    describe 'When I fill in the form with valid data' do
      before :each do
        fill_in 'Discount Name:', with: 'Half Off 2'
        fill_in 'Discount Percentage:', with: 50
        fill_in 'Quantity Threshold:', with: 2

        click_button 'Create Discount'
      end

      it 'I am redirected back to the bulk discount index' do
        expect(current_path).to eq(merchant_discounts_path(@merchant_1.id))
      end

      it 'I see my new bulk discount listed' do
        expect(page).to have_content('Half Off 2')
        expect(page).to have_content("Percentage Discount: 50")
        expect(page).to have_content("Quantity Threshold: 2")
      end
    end
  end
end

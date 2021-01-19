require 'rails_helper'

describe 'As a merchant' do
  describe 'When I visit my edit discount form' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Hair Care')

      @discount_1 = @merchant_1.discounts.create!(name: 'Buy 1 Get 10% Off', percentage_discount: 10.0, quantity_threshold: 1)

      visit edit_merchant_discount_path(@merchant_1.id, @discount_1.id)
    end

    it "I see that the discounts current attributes are prepoluated in the form" do
      expect(page).to have_selector("input[id='discount_name'][value='#{@discount_1.name}']")
      expect(page).to have_selector("input[id='discount_percentage_discount'][value='#{@discount_1.percentage_discount}']")
      expect(page).to have_selector("input[id='discount_quantity_threshold'][value='#{@discount_1.quantity_threshold}']")
    end

    describe 'When I leave the name field empty and click sumbit' do
      it 'I see a flash notice saying the discount failed to update' do
        fill_in 'Discount Name:', with: ''

        click_button 'Update Discount'

        expect(page).to have_content("Discount Update Failed")
      end
    end

    describe 'When I change any/all of the information and click submit' do
      before :each do
        fill_in 'Discount Name:', with: 'Half Off 2'
        fill_in 'Discount Percentage:', with: 50
        fill_in 'Quantity Threshold:', with: 2

        click_button 'Update Discount'
      end

      it "Then I am redirected to the discount's show page" do
        expect(current_path).to eq(merchant_discount_path(@merchant_1, @discount_1))
      end

      it "I see that the discount's attributes have been updated" do
        expect(page).to have_content('Half Off 2')
        expect(page).to have_content("Percentage Discount: 50")
        expect(page).to have_content("Quantity Threshold: 2")
      end

      it 'I see a flash notice saying the discount successfully updated' do
        expect(page).to have_content("Discount Successfully Updated")
      end
    end
  end
end

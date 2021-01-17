require 'rails_helper'

describe "merchant dis edit page" do
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
end

# When I change any/all of the information and click submit
# Then I am redirected to the bulk discount's show page
# And I see that the discount's attributes have been updated

@merchant_a = Merchant.create!(
  name: 'Hair Care'
)

@customer_a = Customer.create!(
  first_name: 'Joey',
  last_name: 'Smith'
)

@invoice_a = Invoice.create!(
  merchant_id: @merchant_a.id,
  customer_id: @customer_a.id,
  status: 2,
  created_at: "2012-03-27 14:54:09"
)

@item_a = @merchant_a.items.create!(
  name: "Shampoo",
  description: "This washes your hair",
  unit_price: 10,
  status: 1
)

@item_b = @merchant_a.items.create!(
  name: "Butterfly Clip",
  description: "This holds up your hair but in a clip",
  unit_price: 10,
  status: 1
)

# Example #1

# @discount_a = @merchant_a.discounts.create!(
#   name: '20% Off 10 Items',
#   percentage_discount: 20.0,
#   quantity_threshold: 10
# )
#
# @invoice_item_a = @invoice_a.invoice_items.create!(
#   item_id: @item_a.id,
#   quantity: 5,
#   unit_price: 10,
#   status: 2
# )
#
# @invoice_item_b = @invoice_a.invoice_items.create!(
#   item_id: @item_b.id,
#   quantity: 5,
#   unit_price: 10,
#   status: 1
# )

# Example 2

# @discount_a = @merchant_a.discounts.create!(
#   name: '20% Off 10 Items',
#   percentage_discount: 20.0,
#   quantity_threshold: 10
# )
#
# @invoice_item_a = @invoice_a.invoice_items.create!(
#   item_id: @item_a.id,
#   quantity: 10,
#   unit_price: 10,
#   status: 2
# )
#
# @invoice_item_b = @invoice_a.invoice_items.create!(
#   item_id: @item_b.id,
#   quantity: 5,
#   unit_price: 10,
#   status: 1
# )

# Example 3

# @discount_a = @merchant_a.discounts.create!(
#   name: '20% Off 10 Items',
#   percentage_discount: 20.0,
#   quantity_threshold: 10
# )
#
# @discount_b = @merchant_a.discounts.create!(
#   name: '30% Off 15 Items',
#   percentage_discount: 30.0,
#   quantity_threshold: 15
# )
#
# @invoice_item_a = @invoice_a.invoice_items.create!(
#   item_id: @item_a.id,
#   quantity: 12,
#   unit_price: 10,
#   status: 2
# )
#
# @invoice_item_b = @invoice_a.invoice_items.create!(
#   item_id: @item_b.id,
#   quantity: 15,
#   unit_price: 10,
#   status: 1
# )

# Example 4

# @discount_a = @merchant_a.discounts.create!(
#   name: '20% Off 10 Items',
#   percentage_discount: 20.0,
#   quantity_threshold: 10
# )
#
# @discount_b = @merchant_a.discounts.create!(
#   name: '15% Off 15 Items',
#   percentage_discount: 15.0,
#   quantity_threshold: 15
# )
#
# @invoice_item_a = @invoice_a.invoice_items.create!(
#   item_id: @item_a.id,
#   quantity: 12,
#   unit_price: 10,
#   status: 2
# )
#
# @invoice_item_b = @invoice_a.invoice_items.create!(
#   item_id: @item_b.id,
#   quantity: 15,
#   unit_price: 10,
#   status: 1
# )

# Example 5

@merchant_b = Merchant.create!(
  name: 'Skin Care'
)

@item_c = @merchant_b.items.create!(
  name: "Skin Lotion",
  description: "Lotion for your skin",
  unit_price: 10,
  status: 1
)

@discount_a = @merchant_a.discounts.create!(
  name: '20% Off 10 Items',
  percentage_discount: 20.0,
  quantity_threshold: 10
)

@discount_b = @merchant_a.discounts.create!(
  name: '30% Off 15 Items',
  percentage_discount: 30.0,
  quantity_threshold: 15
)

@invoice_item_a = @invoice_a.invoice_items.create!(
  item_id: @item_a.id,
  quantity: 12,
  unit_price: 10,
  status: 2
)

@invoice_item_b = @invoice_a.invoice_items.create!(
  item_id: @item_b.id,
  quantity: 15,
  unit_price: 10,
  status: 1
)

@invoice_item_c = @invoice_a.invoice_items.create!(
  item_id: @item_c.id,
  quantity: 15,
  unit_price: 10,
  status: 1
)

class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :merchant_id,
                        :customer_id

  belongs_to :merchant
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  enum status: ['cancelled', 'completed', 'in progress']

  def total_revenue
    invoice_items.each do |invoice_item|
      invoice_item.apply_discount
    end
    invoice_items.sum("unit_price * quantity")
  end
end

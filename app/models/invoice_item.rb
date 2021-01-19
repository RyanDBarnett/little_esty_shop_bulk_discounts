class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item
  has_many :merchants, through: :item
  has_many :discounts, through: :merchants

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def find_discount
    discounts.where('quantity_threshold <= ?', quantity).order(percentage_discount: :desc).first
  end

  def apply_discount
    discount = self.find_discount
    if discount
      self.update!(unit_price: discount.calc_discounted_item_unit_price(item.unit_price))
    else
      self
    end
  end
end

class Discount < ApplicationRecord
  validates_presence_of :quantity_threshold,
                        :percentage_discount,
                        :name

  belongs_to :merchant

  def calc_discounted_item_unit_price unit_price
    unit_price - unit_price * self.percentage_discount * 0.01
  end
end

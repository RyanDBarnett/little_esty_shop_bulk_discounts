class Discount < ApplicationRecord
  validates_presence_of :quantity_threshold,
                        :percentage_discount,
                        :name

  belongs_to :merchant
end

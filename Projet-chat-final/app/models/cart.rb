class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_product(product, currentuser)
    item = line_items.find_by(product: product, current_user_id: currentuser)

    if item
      item.quantity += 1
    else
      item = line_items.new(product: product, current_user_id: currentuser)
    end
    item
  end
  
  def total
    line_items.to_a.sum(&:total)
  end
end

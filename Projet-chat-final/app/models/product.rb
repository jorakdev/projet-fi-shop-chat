class Product < ApplicationRecord
  has_many :line_items, dependent: :nullify
end

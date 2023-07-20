class PostCategoryShip < ApplicationRecord
 has_many :post_category_ships
 has_many :categories, through: :post_category_ships
end

class Skills::Category < ActiveRecord::Base
  validates :name, presence: true
  has_many :sub_categories,-> {includes [:techniques]}, class_name: 'Skills::SubCategory', dependent: :destroy
end
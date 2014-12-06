class Skill < ActiveRecord::Base

  validates :title, presence: true
  has_many :categories,-> {includes [:techniques]}, class_name: 'Skills::Category', dependent: :destroy
end
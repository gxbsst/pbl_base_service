class Role < ActiveRecord::Base
  has_many :assignments, dependent: :destroy, class_name: 'UsersRole'
  has_many :users, through: :assignments
  # belongs_to :resource, :polymorphic => true

  validates_presence_of :name
end

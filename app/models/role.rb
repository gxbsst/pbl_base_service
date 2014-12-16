class Role < ActiveRecord::Base
  has_many :users_roles, dependent: :destroy
  has_many :users, through: :users_roles
  # belongs_to :resource, :polymorphic => true

  validates_presence_of :name
end

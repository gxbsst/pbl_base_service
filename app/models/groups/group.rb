class Groups::Group <  PgConnection
  belongs_to :user
  has_many :member_ships
  has_many :members, through: :member_ships, class_name: 'User', dependent: :destroy
  has_many :posts

  validates :name, presence: true
end

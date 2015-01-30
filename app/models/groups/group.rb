class Groups::Group <  PgConnection
  belongs_to :owner, polymorphic: true
  has_many :member_ships, dependent: :destroy
  has_many :members, through: :member_ships, class_name: 'User', dependent: :destroy
  has_many :posts

  # validates :name, presence: true

  before_create :set_no

  def set_no
    value = ActiveRecord::Migration::execute "SELECT nextval('groups_groups_no_seq')"
    self.no = value[0]["nextval"]
  end

end

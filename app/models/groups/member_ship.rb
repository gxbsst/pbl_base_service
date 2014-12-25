class Groups::MemberShip < PgConnection
  belongs_to :member, class_name: 'User', foreign_key: :user_id
  belongs_to :group
  validates :user_id, :group_id, presence: true
  validates :group_id, uniqueness: {scope: :user_id}
end

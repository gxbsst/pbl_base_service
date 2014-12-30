class Groups::Post < PgConnection
  belongs_to :user
  belongs_to :group
  has_many :replies

  validates :user_id, :group_id, :subject, :body, presence: true
end

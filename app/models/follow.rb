class  Follow < PgConnection
  validates :user_id, uniqueness: {scope: :follower_id}
end

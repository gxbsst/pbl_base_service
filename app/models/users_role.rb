class UsersRole < PgConnection
  belongs_to :user
  belongs_to :role
end
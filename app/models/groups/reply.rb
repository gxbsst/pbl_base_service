class Groups::Reply < PgConnection
  belongs_to :user
  belongs_to :post
end

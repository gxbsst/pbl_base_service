class Feeds::Message < PgConnection

  before_save :init
  belongs_to :post
  belongs_to :sender, class_name: 'User'
  belongs_to :user

  private

  def init
    self.post_no = self.post.no
    self.sender = self.post.user
    self.created_at = self.post.created_at
    true
  end
end

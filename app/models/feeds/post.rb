class Feeds::Post < PgConnection

  has_many :messages,  dependent: :destroy
  belongs_to :user
  belongs_to :sender, class_name: 'User'
  validates :content, presence: true

  before_create :set_no
  after_create :deliver_messages

  private

  def set_no
    value = ActiveRecord::Migration::execute "SELECT nextval('feeds_post_no_seq')"
    self.no = value[0]["nextval"]
  end


  def deliver_messages
    message = Feeds::Message.where(user_id: self.user_id, post_id: self.id).first
    unless message
      Feeds::Message.create(post_id: self.id, user_id: self.user_id)
    end
    MessageDeliveryWorker.perform_async(self.id.to_s)
  end

end

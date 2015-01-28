class Todos::Todo < PgConnection

  has_many :recipients, class_name: 'Todos::Recipient', dependent: :destroy
  has_many :todo_items, :class_name => 'Todos::TodoItem'

  attr_accessor :recipient

  after_create :create_recipients

  private

  def create_recipients
    if self.recipient.present?
      self.recipients.create(self.recipient)
    end
  end

end

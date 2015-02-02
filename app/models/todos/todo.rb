class Todos::Todo < PgConnection

  has_many :recipients, class_name: 'Todos::Recipient', dependent: :destroy
  has_many :todo_items, :class_name => 'Todos::TodoItem'

  attr_accessor :recipient

  after_create :create_recipients
  before_save :sync_todo_items


  def sync_todo_items
   if self.recipient.present?
     if add_recipients.present?
       self.recipients.create(add_recipients)
     end

     if delete_recipients.present?
       delete_recipients.each do |r|
         self.recipients.find_by_assignee_id_and_assignee_type(r.fetch(:assignee_id),
                                                               r.fetch(:assignee_type)).try(:destroy)
       end
     end
   end
  end

  private

  def create_recipients
    if self.recipient.present?
      self.recipients.create(self.recipient)
    end
  end

  def origin_recipients
    self.recipients.collect {|r| {assignee_id: r.assignee_id, assignee_type: r.assignee_type}}
  end

  def update_recipients
    self.recipient.collect { |r| {assignee_id: r[:assignee_id], assignee_type: r[:assignee_type] }  }
  end

  def exist_recipients
    update_recipients & origin_recipients
  end

  def delete_recipients
    (origin_recipients - exist_recipients).uniq
  end

  def add_recipients
    (update_recipients - exist_recipients).uniq
  end

end

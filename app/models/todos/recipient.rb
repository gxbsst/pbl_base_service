class Todos::Recipient < PgConnection

  after_create :deliver_todo_items

  has_many :todo_items, :class_name => 'Todos::TodoItem', dependent: :destroy
  belongs_to :todo

  private

  def deliver_todo_items
    TodoItemDeliveryWorker.perform_async(self.id.to_s)
  end

end

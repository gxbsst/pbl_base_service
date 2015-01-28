class Todos::Recipient < PgConnection

  after_create :create_todo_items

  has_many :todo_items, :class_name => 'Todos::TodoItem', dependent: :destroy
  belongs_to :todo

  private

  def create_todo_items
    if self.assignee_type == 'Clazz'
      clazz = Clazz.includes(:students).find(self.assignee_id)
      clazz.students.each do |student|
        self.todo_items.create(
                           user_id: student.user_id,
                           todo_id: self.todo_id
        )
      end
    end
  end
end

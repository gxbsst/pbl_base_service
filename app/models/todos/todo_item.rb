class Todos::TodoItem < PgConnection

  belongs_to :todo, :class_name => 'Todos::Todo'
  belongs_to :recipient, :class_name => 'Todos::Recipient'

  delegate :start_at, :end_at, :repeat_by, :content, to: :todo

  state_machine :state, :initial => :opening do
    event :complete do
      transition [:opening] => :completed
    end

    event :do_open do
      transition [:completed] => :opening
    end
  end

  def sender_id
   self.todo.user_id
  end

end

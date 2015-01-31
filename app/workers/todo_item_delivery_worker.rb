class TodoItemDeliveryWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :default

  def perform(recipient_id)
    recipient = Todos::Recipient.find(recipient_id)

    case recipient.assignee_type
      when 'Clazz'
        clazz = Clazz.includes(:students).find(recipient.assignee_id)
        clazz.students.each do |student|
          deliver(recipient, student.user_id)
        end
      when 'User'
        user = User.find(recipient.assignee_id)
        deliver(recipient, user.id)
      else
        raise 'Only Clazz and user can receive message'
    end
  end


  private

  def deliver(recipient, user_id)
    begin
      recipient.todo_items.create(
          user_id: user_id,
          todo_id: recipient.todo_id
      )
    rescue => e
      Sidekiq.logger.fatal(e)
    end
  end
end

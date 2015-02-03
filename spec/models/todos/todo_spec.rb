require 'rails_helper'

RSpec.describe Todos::Todo, :type => :model do

  describe '#sync_todo_items' do
    let!(:clazz_1) { create :clazz_with_students }
    let!(:clazz_2) { create :clazz_with_students }
    let!(:clazz_3) { create :clazz_with_students }
    let(:user) { create :user }
    let!(:recipient) { [{assignee_type: 'Clazz', assignee_id: clazz_1.id}, {assignee_type: 'Clazz', assignee_id: clazz_2.id}]}
    let!(:todo ) { create :todos_todo, user_id: user.id, recipient: recipient  }

    it { expect(Todos::Todo.first.origin_recipients).to match_array(recipient) }

    it 'update recipient' do
      update_recipients = [
          { assignee_type: 'Clazz',
            assignee_id: clazz_1.id
          },
          { assignee_type: 'Clazz',
            assignee_id: clazz_3.id
          }
      ]
      todo.recipient = update_recipients

      expect(todo.update_recipients).to match_array(update_recipients)
      expect(todo.delete_recipients).to match_array([recipient[1]])
      expect(todo.add_recipients).to match_array([update_recipients[1]])

      expect(todo.recipients.count).to eq(2)
      todo.sync_todo_items
      expect(Todos::Recipient.count).to eq(1)
    end

  end
end

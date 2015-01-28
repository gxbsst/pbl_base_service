require 'rails_helper'

RSpec.describe Todos::TodoItem, :type => :model do

  describe '#state' do
    let(:todo_item) { described_class.create }

    it { expect(todo_item.state).to eq('opening')}

    it ' compete ' do
      todo_item.complete
      expect(todo_item.state).to eq('completed')
    end

    it ' reopen' do
      todo_item.complete
      todo_item.do_open
      expect(todo_item.state).to eq('opening')
    end

  end

  describe '#delegate' do
    let!(:user) { create :user}
    let!(:clazz) { create :clazz_with_students }
    let!(:todo) { create :todos_todo, start_at: Time.now + 1.days, end_at: Time.now + 5.days, content: 'content', repeat_by: 'day', user_id: user.id}
    let(:todo_item) { Todos::TodoItem.create(todo_id: todo.id)}

    it { expect(todo_item.start_at).to_not be_nil }
    it { expect(todo_item.end_at).to_not be_nil }

    it { expect(todo_item.content).to eq('content')}
    it { expect(todo_item.repeat_by).to eq('day')}

  end
end

require 'rails_helper'
describe V1::Todo::TodoItemsController do
  let(:user) { create :user }
  let!(:clazz) { create :clazz_with_students }
  let!(:todo) { create :todos_todo, start_at: Time.now + 1.days, end_at: Time.now + 5.days, content: 'content', repeat_by: 'day', user_id: user.id}
  let!(:recipient) { create :todos_recipient, todo_id: todo.id, assignee_type: 'Clazz', assignee_id: clazz.id   }

  describe 'GET #index' do

    let!(:todo_item) { Todos::TodoItem.create(todo_id: todo.id, user_id: user.id, recipient_id: recipient.id) }

    context 'get index' do
      before(:each) do
        get "/todo/todo_items", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(response.body).to have_json_type(Hash)}
      it { expect(@json['data'].size).to eq(1)}
    end

    context 'with user_id' do
      let(:user_1) { create :user }
      let!(:todo_item) { Todos::TodoItem.create(todo_id: todo.id, user_id: user_1.id, recipient_id: recipient.id) }

      before(:each) do
        get "/todo/todo_items/", {user_id: user_1.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1)}
    end

  end

  describe 'POST #create' do
    let!(:todo_item) { attributes_for :todos_todo_item, todo_id: todo.id, user_id: user.id, recipient_id: recipient.id  }
    before(:each) do
      post "/todo/todo_items", {todo_item: todo_item}, accept
    end

    it { expect(Todos::TodoItem.count).to eq(1)}
  end

  describe 'GET #show' do
    let!(:todo_item) { Todos::TodoItem.create(todo_id: todo.id, user_id: user.id, recipient_id: recipient.id) }
    before(:each) do
      get "/todo/todo_items/#{todo_item.id}", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(todo_item.id)}
    it { expect(@json['start_at']).to_not be_nil }
    it { expect(@json['end_at']).to_not be_nil }
    it { expect(@json['content']).to eq('content') }
    it { expect(@json['repeat_by']).to eq('day') }
    it { expect(@json['user_id']).to eq(user.id) }
    it { expect(@json['recipients']).to be_a Array}
    it { expect(@json['sender_id']).to eq(todo.user_id)}
  end

  describe 'DELETE #destroy' do
    let!(:todo_item) { Todos::TodoItem.create(todo_id: todo.id, user_id: user.id, recipient_id: recipient.id) }
    it { expect{  delete "/todo/todo_items/#{todo_item.id}", {}, accept }.to change(Todos::TodoItem, :count).from(1).to(0) }
  end
end
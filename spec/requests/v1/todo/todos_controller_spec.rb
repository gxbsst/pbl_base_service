require 'rails_helper'
describe V1::Todo::TodosController do

  let!(:user) { create :user}
  let!(:clazz) { create :clazz_with_students }

  describe 'GET #index' do

    let!(:todo) { create :todos_todo, start_at: Time.now + 1.days, end_at: Time.now + 5.days, content: 'content', repeat_by: 'day', user_id: user.id}
    let!(:recipient) { create :todos_recipient, todo_id: todo.id, assignee_type: 'Clazz', assignee_id: clazz.id   }

    context 'get index' do
      before(:each) do
        get "/todo/todos", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(response.body).to have_json_type(Hash)}
      it { expect(@json['data'].size).to eq(1)}
    end

    context 'with user_id' do
      let(:user_1) { create :user }
      let!(:todo) { create :todos_todo, start_at: Time.now + 1.days, end_at: Time.now + 5.days, content: 'content', repeat_by: 'day', user_id: user_1.id }

      before(:each) do
        get "/todo/todos/", {user_id: user_1.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1)}
    end

  end

  describe 'POST #create' do

    let(:user) { create :user }
    let!(:recipient) { [{assignee_type: 'Clazz', assignee_id: clazz.id }]}
    let!(:params) { attributes_for :todos_todo, start_at: Time.now + 1.days, end_at: Time.now + 5.days, content: 'content', repeat_by: 'day', user_id: user.id, recipient: recipient  }
    before(:each) do
      post "/todo/todos", {todo: params}, accept
    end

    it { expect(Todos::Todo.count).to eq(1)}
    it { expect(Todos::Todo.first.recipients.size).to eq(1)}
    # it { expect(Todos::TodoItem.count).to eq(5)}
  end

  describe 'GET #show' do
    let!(:todo) { create :todos_todo, start_at: Time.now + 1.days, end_at: Time.now + 5.days, content: 'content', repeat_by: 'day', user_id: user.id}
    before(:each) do
      get "/todo/todos/#{todo.id}", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(todo.id)}
    it { expect(@json['start_at']).to_not be_nil }
    it { expect(@json['end_at']).to_not be_nil }
    it { expect(@json['content']).to eq('content') }
    it { expect(@json['repeat_by']).to eq('day') }
    it { expect(@json['user_id']).to eq(user.id) }
    it { expect(@json['recipients']).to eq([])}
  end

  describe 'DELETE #destroy' do
    let!(:message) { create :feeds_message,  user_id: user.id, post_id: post_0.id }
    it { expect{  delete "/feed/messages/#{message.id}", {}, accept }.to change(Feeds::Message, :count).from(1).to(0) }
  end
end

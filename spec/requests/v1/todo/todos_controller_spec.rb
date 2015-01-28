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
    let!(:recipient) { {assignee_type: 'Clazz', assignee_id: clazz.id }}
    let!(:params) { attributes_for :todos_todo, start_at: Time.now + 1.days, end_at: Time.now + 5.days, content: 'content', repeat_by: 'day', user_id: user.id, recipient: recipient  }
    before(:each) do
      post "/todo/todos", {todo: params}, accept
    end

    it { expect(Todos::Todo.count).to eq(1)}
    it { expect(Todos::Todo.first.recipients.size).to eq(1)}
    it { expect(Todos::TodoItem.count).to eq(5)}
  end

  # describe 'DELETE #destroy' do
  #   let(:user) { create :user }
  #   let!(:group) { create :group, owner_id: user.id, owner_type: user.class.name}
  #   before(:each) do
  #     delete "/group/groups/#{group.id}", {}, accept
  #   end
  #
  #   it { expect(Groups::Group.count).to eq(0)}
  # end
  #
  # describe 'GET #show' do
  #   context 'with include member_ships' do
  #     let(:user) { create :user }
  #     let!(:group) { create :group_with_members, owner_id: user.id, owner_type: user.class.name, members_count: 5}
  #     before(:each) do
  #       get "/group/groups/#{group.id}", {include: 'member_ships'}, accept
  #       @json = parse_json(response.body)
  #     end
  #
  #     it { expect(@json['member_ships'].count).to eq(5) }
  #     it { expect(@json['member_ships'][0]['role']).to match_array([]) }
  #     it { expect(@json['member_ships'][0]['member']['username']).to_not be_nil  }
  #   end
  # end
end

require 'rails_helper'

describe V1::AssignmentsController do

  describe 'GET #index' do
    let!(:resource) { create :pbl_project }
    let!(:role) { create :user_with_assignments, name: 'teacher', resource_id: resource.id, resource_type: 'Project', assignments_count: 5}
    before(:each) do
      get "/assignments?resource_type=Project&name=teacher&resource_id=#{resource.id}", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Hash)}
    it { expect(@json['data'].size).to eq(5)}
    it { expect(@json['data'][0]['role_id']).to eq(role.id)}
    it { expect(@json['data'][0]['user_id']).to_not be_nil}
    it { expect(@json['data'][0]['id']).to_not be_nil}

    context 'with include user' do
      before(:each) do
        get "/assignments?resource_type=Project&name=teacher&resource_id=#{resource.id}&include=user", {}, accept
        @json = parse_json(response.body)
      end
      it { expect(@json['data'][0]['user']).to be_a Hash}
      it { expect(@json['data'][0]['user']['username']).to_not be_nil }
      it { expect(@json['data'][0]['user']['email']).to_not be_nil }
    end
  end

  describe 'POST #create' do
    let(:user) { create :user }
    let(:resource) { create :pbl_project }
    before(:each) do
      params = {
        name: 'teacher',
        user_id: user.id,
        resource_type: resource.class.name.demodulize,
        resource_id: resource.id
      }
      post "/assignments", {assignment: params}, accept
    end

    it { expect(UsersRole.count).to eq(1)}

    describe 'with errors' do
      let(:user_1) { create :user }
      let(:resource_1) { create :pbl_project }
      before(:each) do
        params = [
          {
            name: 'teacher',
            user_id: user_1.id,
            resource_type: resource_1.class.name.demodulize,
            resource_id: resource_1.id
          },
          {
            name: 'teacher',
            user_id: user_1.id,
            resource_type: resource_1.class.name.demodulize,
            resource_id: resource_1.id
          }
        ]
        post "/assignments", {assignment: params}, accept
        @json = parse_json(response.body)
      end

      it{ expect(@json["error"].size).to eq(1)}

    end
  end

  describe 'DELETE #destroy' do
    context 'with ids' do
      let(:users_role_1) { create :users_role }
      let(:users_role_2) { create :users_role }

      before(:each) do
        delete "/assignments/#{users_role_1.id},#{users_role_2.id}", {}, accept
      end

      it { expect(UsersRole.count).to eq(0)}
    end

    context 'with id' do

      let(:user) { create :user }
      let(:resource) { create :pbl_project }
      let(:role) { create :role, name: 'teacher', resource_id: resource.id, resource_type: 'Project' }
      let!(:users_role) { create :users_role, user_id: user.id, role_id: role.id  }

      before(:each) do
        delete "/assignments/#{users_role.id}", {}, accept
      end

      it { expect(UsersRole.count).to eq(0)}
    end
  end
end
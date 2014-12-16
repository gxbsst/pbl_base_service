require 'rails_helper'

describe V1::UsersRolesController do

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
      post "/users_roles", {users_role: params}, accept
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
        post "/users_roles", {users_role: params}, accept
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
        delete "/users_roles/#{users_role_1.id},#{users_role_2.id}", {}, accept
      end

      it { expect(UsersRole.count).to eq(0)}
    end

    context 'with id' do
      let(:users_role) { create :users_role }

      before(:each) do
        delete "/users_roles/#{users_role.id}", {}, accept
      end

      it { expect(UsersRole.count).to eq(0)}
    end
  end
end
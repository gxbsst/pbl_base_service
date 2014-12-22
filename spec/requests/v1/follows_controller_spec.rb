require 'rails_helper'
describe V1::FollowsController do
  describe 'GET #index' do
    let!(:user) { create :user, username: 'username'}
    let!(:follower) { create :user, username: 'follower'}
    let!(:friend_ship) { create :follow, user_id: user.id, follower_id: follower.id}
    before(:each) do
      get "/follows", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Hash)}
    it { expect(@json['data'].size).to eq(1)}
    it { expect(@json['data'][0]['follower_id']).to eq(follower.id)}
    it { expect(@json['data'][0]['user_id']).to eq(user.id)}
    it { expect(@json['data'][0]['id']).to_not be_nil}

  end

  describe 'POST #create' do

    context 'follow a user ' do
      let(:user) { create :user }
      let(:follower) { create :user }
      before(:each) do
        params = {
          user_id: user.id,
          follower_id: follower.id
        }
        post "/follows", {follow: params}, accept
      end

      it { expect(Follow.count).to eq(1)}
    end

    context 'become a friend' do
      let(:user) { create :user }
      let(:follower) { create :user }
      let!(:following) { create :follow, user_id: follower.id, follower_id: user.id}
       before(:each) do
         params = {
           user_id: user.id,
           follower_id: follower.id
         }
         post "/follows", {follow: params}, accept
       end

       it { expect(Follow.count).to eq(2)}
       it { expect(Friend.count).to eq(2) }
    end

    # describe 'with errors' do
    #   let(:user_1) { create :user }
    #   let(:resource_1) { create :pbl_project }
    #   before(:each) do
    #     params = [
    #       {
    #         name: 'teacher',
    #         user_id: user_1.id,
    #         resource_type: resource_1.class.name.demodulize,
    #         resource_id: resource_1.id
    #       },
    #       {
    #         name: 'teacher',
    #         user_id: user_1.id,
    #         resource_type: resource_1.class.name.demodulize,
    #         resource_id: resource_1.id
    #       }
    #     ]
    #     post "/assignments", {assignment: params}, accept
    #     @json = parse_json(response.body)
    #   end
    #
    #   it{ expect(@json["error"].size).to eq(1)}
    #
    # end
  end

  # describe 'DELETE #destroy' do
  #   let(:role) { create :role, name: 'teacher'}
  #   context 'with ids' do
  #     let(:users_role_1) { create :users_role, role_id: role.id }
  #     let(:users_role_2) { create :users_role, role_id: role.id }
  #
  #     before(:each) do
  #       delete "/assignments/#{users_role_1.id},#{users_role_2.id}", {}, accept
  #     end
  #
  #     it { expect(UsersRole.count).to eq(0)}
  #   end
  #
  #   context 'with id' do
  #
  #     let(:user) { create :user }
  #     let(:resource) { create :pbl_project }
  #     let(:role) { create :role, name: 'teacher', resource_id: resource.id, resource_type: 'Project' }
  #     let!(:users_role) { create :users_role, user_id: user.id, role_id: role.id  }
  #
  #     before(:each) do
  #       delete "/assignments/#{users_role.id}", {}, accept
  #     end
  #
  #     it { expect(UsersRole.count).to eq(0)}
  #   end
  # end
end

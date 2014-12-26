require 'rails_helper'
describe V1::FollowsController do
  describe 'GET #index' do
    let!(:user) { create :user, username: 'username'}
    let!(:follower) { create :user, username: 'follower'}
    let!(:follow) { create :follow, user_id: user.id, follower_id: follower.id}
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
       it { expect(FriendShip.count).to eq(2) }
       it { expect(user.friends.count).to eq(1) }
       it { expect(follower.friends.count).to eq(1) }
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create :user }
    let(:follower) { create :user }
    context 'with follow' do

      let!(:following) { create :follow, user_id: user.id, follower_id: follower.id}
      before(:each) do
        delete "/follows/#{following.id}", {}, accept
      end

      it { expect(Follow.count).to eq(0)}
    end

    context 'with un-follow with dose exit follow' do
      let!(:following) { create :follow, user_id: follower.id, follower_id: user.id}
        before(:each) do
          delete "/follows/#{user.id}", {}, accept
          @json = parse_json(response.body)
        end

      it { expect(Follow.count).to eq(1)}
      it { expect(@json['error']).to_not  be_nil}
    end
  end
end

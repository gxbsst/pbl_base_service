require 'rails_helper'

describe CreatingFriendShip do

  describe ".create" do
    let(:user) { create :user }
    let(:friend) { create :user }
    let(:params) {
      {user_id: user.id, friend_id: friend.id, relation: '00001'}
    }
    let(:listener) { double.as_null_object }

    it { expect{CreatingFriendShip.create(listener, params) }.to change(FriendShip, :count).from(0).to(2)}
    it 'create a friend_ship' do
      CreatingFriendShip.create(listener, params)
      user.reload
      expect(user.followings_count).to eq(1)
      expect(user.followers_count).to eq(1)
      expect(user.friends_count).to eq(1)
    end

  end
end
require 'rails_helper'

describe CreatingFollow do

  let(:listener) { double.as_null_object }
  describe ".create" do
    context 'with create' do
      let(:user) { create :user }
      let(:follower) { create :user }
      before(:each) do
        CreatingFollow.create(listener, user, follower)
      end

      it 'create a follow' do
        user.reload
        follower.reload
        expect(Follow.count).to eq(1)
        expect(user.followers_count).to eq(1)
        expect(user.followings_count).to eq(0)
        expect(follower.followers_count).to eq(0)
        expect(follower.followings_count).to eq(1)
      end
    end

    context 'with repeat follow' do
      let(:user) { create :user }
      let(:follower) { create :user }
      before(:each) do
        expect(listener).to receive(:on_create_error)
        CreatingFollow.create(listener, user, follower)
      end

      it 'repeat follow' do
        CreatingFollow.create(listener, user, follower)
        expect(Follow.count).to eq(1)
      end
    end

    context 'with follow together' do
      let(:user) { create :user }
      let(:follower) { create :user }
      before(:each) do
        CreatingFollow.create(listener, user, follower)
      end

      it 'follow together' do
        follower.reload
        user.reload
        CreatingFollow.create(listener, follower, user)
        expect(Follow.count).to eq(2)
        expect(FriendShip.count).to eq(2)
        expect(follower.friends_count).to eq(1)
        expect(user.friends_count).to eq(1)
      end
    end
  end
end
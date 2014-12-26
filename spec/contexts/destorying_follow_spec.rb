require 'rails_helper'

describe DestroyingFollow do

  describe ".destroy" do
    let(:user) { create :user }
    let(:follower) { create :user }
    let(:listener) { double.as_null_object }
    let(:params) {
      {user_id: user.id, follower_id: follower.id}
    }
    before(:each) do
      CreatingFollow.create(listener, user, follower)
    end

    it { expect(Follow.count).to eq(1)}
    it { expect{DestroyingFollow.destroy(listener, Follow.first) }.to change(Follow, :count).from(1).to(0)}

    context 'un-follow for a friendship' do
      before(:each) do
        expect(listener).to receive(:on_create_success)
        CreatingFollow.create(listener, user, follower)
        CreatingFollow.create(listener, follower, user)
      end

      it 'un-follow the user' do
        expect(FriendShip.count).to eq(2)
        expect{DestroyingFollow.destroy(listener, Follow.first.id)}.to change(FriendShip, :count).from(2).to(0)
      end
    end

    context 'with un-followed' do
      before(:each) do
        expect(listener).to receive(:on_create_error)
        CreatingFollow.create(listener, user, follower)
        DestroyingFollow.destroy(listener, Follow.first)
      end

      it 'repeat follow' do
        DestroyingFollow.destroy(listener, Follow.first)
      end
    end

  end
end
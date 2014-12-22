require 'rails_helper'

describe DestroyingFollow do

  describe ".destroy" do
    let(:user) { create :user }
    let(:follower) { create :user }
    let(:listener) { double.as_null_object }
    before(:each) do
      CreatingFollow(listener, user, follower)
    end

    it { expect{DestroyingFollow.destroy(listener, user, follower) }.to change(Follow, :count).from(1).to(0)}

    context 'with repeat follow' do
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
      before(:each) do
        CreatingFollow.create(listener, user, follower)
      end

      it 'follow together' do
        CreatingFollow.create(listener, follower, user)
        expect(Follow.count).to eq(2)
        expect(Friend.count).to eq(1)
      end
    end
  end
end
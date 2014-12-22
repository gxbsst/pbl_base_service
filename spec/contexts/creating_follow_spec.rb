require 'rails_helper'

describe CreatingFollow do

  describe ".create" do
    let(:user) { create :user }
    let(:follower) { create :user }
    let(:listener) { double.as_null_object }

    it { expect{CreatingFollow.create(listener, user, follower) }.to change(Follow, :count).from(0).to(1)}

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
        expect(Friend.count).to eq(2)
      end
    end
  end
end
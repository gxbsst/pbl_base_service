require 'rails_helper'

RSpec.describe FriendShip, :type => :model do
  it { expect(described_class.new).to belong_to(:user)}

  describe 'validate' do
    let(:user) { create :user}
    let(:friend) { create :user}
    before(:each) do
      FriendShip.create(user_id: user.id, friend_id: friend.id)
    end

    it "create a repeat item" do
      f = FriendShip.new(user_id: user.id, friend_id: friend.id)
      expect(f.valid?).to be_falsey
    end
  end
end

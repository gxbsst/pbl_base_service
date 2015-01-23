require 'rails_helper'

RSpec.describe Feeds::Post, :type => :model do
  it { expect(described_class.new).to have_many :messages }
  it { expect(described_class.new).to validate_presence_of(:content)}

  describe '#deliver_message' do
    let(:owner)  { create :user }
    let(:follower) { create :user }
    let(:follow) { create :follow, user_id: owner.id, follower_id: follower.id }

    before(:each) do
     Feeds::Post.create(user_id: owner.id, owner_type: owner.class.name, owner_id: owner.id, content: 'hahha.....')
    end

    it { expect(Feeds::Message.count).to eq(2) }
  end
end

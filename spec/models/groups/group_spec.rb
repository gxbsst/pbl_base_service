require 'rails_helper'

RSpec.describe Groups::Group, :type => :model do
  it { expect(described_class.new).to have_many(:members) }
  it { expect(described_class.new).to validate_presence_of(:name) }

  describe '#members' do
    let(:group) { create :group }
    let(:user) { create :user }
    let!(:member_ship) { create :member_ship, user_id: user.id, group_id: group.id}

    it { expect(group.members).to match_array([user])}
  end

  describe '#destroy' do
    let(:user) { create :user }
    before(:each) do
      listener = double.as_null_object
      CreatingGroup.create(listener, name: 'name', user_id: user.id)
    end

    it "destroy a group" do
      expect(Groups::MemberShip.count).to eq(1)
      expect(Groups::Group.count).to eq(1)
      Groups::Group.first.destroy
      expect(Groups::MemberShip.count).to eq(0)
      expect(Groups::Group.count).to eq(0)
    end

  end
end

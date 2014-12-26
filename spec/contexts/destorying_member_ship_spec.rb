require 'rails_helper'

describe DestroyingMemberShip do

  describe ".destroy" do
    context 'it destroy member_ship' do
      let(:user) { create :user }
      let(:group) { create :group}
      let(:listener) { double.as_null_object }
      let!(:member_ship) { create :member_ship, user_id: user.id, group_id: group.id}

      it { expect{DestroyingMemberShip.destroy(listener, member_ship.id) }.to change(Groups::MemberShip, :count).from(1).to(0)}
    end

    context 'leave  a group' do
      let(:user) { create :user }
      let(:group) { create :group}
      let(:listener) { double.as_null_object }
      before(:each) do
        expect(listener).to receive(:on_destroy_success)
        @member_ship = CreatingMemberShip.create(listener, attributes_for(:member_ship, user_id: user.id, group_id: group.id))
      end

      it 'leave a group' do
        expect(Groups::MemberShip.count).to eq(1)
        expect(Groups::Group.first.members_count).to eq(1)
        expect{DestroyingMemberShip.destroy(listener, Groups::MemberShip.first.id)}.to change(Groups::MemberShip, :count).from(1).to(0)
      end

      it "members_count will decrease 1" do
        group.reload
        expect(group.members_count).to eq(1)
        DestroyingMemberShip.destroy(listener, Groups::MemberShip.first.id)
        group.reload
        expect(group.members_count).to eq(0)
      end
    end

    context 'with un-followed' do

      let(:user) { create :user }
      let(:group) { create :group}
      let(:listener) { double.as_null_object }
      before(:each) do
        expect(listener).to receive(:on_destroy_error)
        CreatingMemberShip.create(listener, attributes_for(:member_ship, user_id: user.id, group_id: group.id))
        @member_ship =  Groups::MemberShip.first
        DestroyingMemberShip.destroy(listener, @member_ship.id)
      end

      it 'repeat follow' do
        DestroyingMemberShip.destroy(listener, @member_ship.id)
      end
    end

  end
end
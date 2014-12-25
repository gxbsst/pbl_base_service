require 'rails_helper'

describe CreatingMemberShip do

  describe ".create" do
    let(:user) { create :user }
    let(:group) { create :group }
    let(:params) {
      {user_id: user.id, group_id: group.id}
    }
    let(:listener) { double.as_null_object }

    it { expect{CreatingMemberShip.create(listener, params) }.to change(Groups::Group, :count).from(0).to(1)}
    it 'create a member_ship' do
      CreatingMemberShip.create(listener, params)
      group.reload

      expect(Groups::Group.first.members_count).to eq(1)
    end

    context 'with repeat join' do
      before(:each) do
        expect(listener).to receive(:on_create_error)
        CreatingMemberShip.create(listener, params)
      end

      it 'repeat join' do
        CreatingMemberShip.create(listener, params)
        expect(Groups::Group.count).to eq(1)
        expect(Groups::Group.first.members_count).to eq(1)
      end
    end

  end
end
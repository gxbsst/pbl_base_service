require 'rails_helper'

describe CreatingGroup  do
  describe '.create' do
    let(:user) { create :user }
    let(:listener) { double.as_null_object }
    let(:params) {
      {
        group: {
          owner_id: user.id,
          owner_type: user.class.name,
          name: 'group_name',
          description: 'description'
        }
      }
    }
    before(:each) do
      expect(listener).to receive(:on_create_success)
    end
    it "create a group" do
      CreatingGroup.create(listener, params[:group])
      expect(Groups::Group.count).to eq(1)
      expect(Groups::MemberShip.count).to eq(1)
      expect(Groups::MemberShip.first.role).to match_array(['creator'])
    end
  end
end
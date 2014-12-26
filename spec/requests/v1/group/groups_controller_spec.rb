require 'rails_helper'
describe V1::Group::GroupsController do
  describe 'GET #index' do
    let!(:user) { create :user, username: 'username'}
    let!(:group) { create :group, user_id: user.id}
    before(:each) do
      get "/group/groups", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Hash)}
    it { expect(@json['data'].size).to eq(1)}
    it { expect(@json['data'][0]['user_id']).to eq(user.id)}
    it { expect(@json['data'][0]['id']).to_not be_nil}

    context 'with ids' do
      let!(:group_1) { create :group, user_id: user.id}
      let!(:group_2) { create :group, user_id: user.id}
      before(:each) do
        get "/group/groups/#{group_1.id},#{group_2.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json.size).to eq(2)}
      it { expect(@json['data'][0]['name']).to eq('name') }
      it { expect(@json['data'][1]['name']).to eq('name') }
    end

    context 'with user_id' do
      let(:user_1) { create :user }
      let!(:group_3) { create :group, user_id: user_1.id}
      let!(:group_1) { create :group, user_id: user.id}
      let!(:group_2) { create :group, user_id: user.id}
      before(:each) do
        get "/group/groups/#{group_1.id},#{group_2.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json.size).to eq(2)}
      it { expect(@json['data'][0]['name']).to eq('name') }
      it { expect(@json['data'][1]['name']).to eq('name') }
    end

  end

  describe 'POST #create' do

    context 'create a group with success' do
      let(:user) { create :user }
      before(:each) do
        params = {
          user_id: user.id,
          name: 'name',
          description: 'description'
        }
        post "/group/groups", {group: params}, accept
      end

      it { expect(Groups::Group.count).to eq(1)}
      it { expect(Groups::MemberShip.count).to eq(1)}
    end

    context 'create a group with error' do
      let(:user) { create :user }
      before(:each) do
        params = {
          user_id: user.id,
          name: '',
          description: 'description'
        }
        post "/group/groups", {group: params}, accept
      end

      it { expect(Groups::Group.count).to eq(0)}
      it { expect(Groups::MemberShip.count).to eq(0)}
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create :user }
    let!(:group) { create :group, user_id: user.id}
    before(:each) do
      delete "/group/groups/#{group.id}", {}, accept
    end

    it { expect(Groups::Group.count).to eq(0)}
  end

  describe 'GET #show' do
    context 'with include member_ships' do
      let(:user) { create :user }
      let!(:group) { create :group_with_members, user_id: user.id, members_count: 5}
      before(:each) do
        get "/group/groups/#{group.id}", {include: 'member_ships'}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['member_ships'].count).to eq(5) }
      it { expect(@json['member_ships'][0]['role']).to match_array([]) }
      it { expect(@json['member_ships'][0]['member']['username']).to_not be_nil  }
    end
  end
end

require 'rails_helper'

describe V1::Group::MembersController do
  let(:group) { create :group}
  let(:user_1) { create :user}
  let(:user_2) { create :user}

  describe 'GET #index' do
    let!(:clazz_instance_1)  { create :member_ship, group_id: group.id, user_id: user_1.id }
    let!(:clazz_instance_2)  { create :member_ship, group_id: group.id, user_id: user_2.id }

    before(:each) do
      get '/group/members', {group_id: group.id}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Hash) }
    it { expect(@json['data'].size).to eq(2)}
    it { expect(@json['data'][0]['role']).to eq([])}

    context 'with page' do
      context 'page 1' do
        before(:each) do
          get '/group/members?page=1&limit=1', {group_id: group.id}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['meta']['total_pages']).to eq(2)}
        it { expect(@json['meta']['current_page']).to eq(1)}
        it { expect(@json['meta']['per_page']).to eq('1')}

      end
    end
  end

  describe 'GET #show' do
    context 'with found' do
      let!(:clazz_instance)  { create :member_ship, group_id: group.id, user_id: user_1.id }
      before(:each) do
        get "/group/members/#{clazz_instance.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['id']).to eq(user_1.id.to_s) }
    end

    context 'with not found' do
      before(:each) do
        get '/group/members/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
      end

      it { expect(response.status).to  eq(404) }
    end
  end

  describe 'POST #create' do
    context 'with successful' do
      before(:each) do
        post '/group/members/actions/join', { member: attributes_for(:member_ship, group_id: group.id, user_id: user_1.id) }, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['id']).to eq(user_1.id) }
    end

    context 'with failed' do
      it { expect {post '/group/members', { member: attributes_for(:member_ship) }, accept }.to raise_error(RuntimeError) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:clazz_instance)  { create :member_ship, group_id: group.id, user_id: user_1.id }
    it { expect{  delete "group/members/leave",  { member: attributes_for(:member_ship, group_id: group.id, user_id: user_1.id) }, accept }.to change(Groups::MemberShip, :count).from(1).to(0) }
  end
end
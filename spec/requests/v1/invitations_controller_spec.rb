require 'rails_helper'

RSpec.describe V1::InvitationsController, :type => :request do
  let!(:user) { create :user }
  describe 'GET #index' do
    let!(:invitation) { create :invitation, owner_type: user.class.name, owner_id: user.id }
    before(:each) do
      get "/invitations", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Hash)}
    it { expect(@json['data'].size).to eq(1)}
    it { expect(@json['data'][0]['owner_id']).to eq(user.id)}
    it { expect(@json['data'][0]['owner_type']).to eq(user.class.name)}
    it { expect(@json['data'][0]['id']).to_not be_nil}
    it { expect(@json['data'][0]['code']).to_not be_nil}

    context 'with ids' do
      let!(:invitation_1) { create :invitation, owner_type: user.class.name, owner_id: user.id }
      let!(:invitation_2) { create :invitation, owner_type: user.class.name, owner_id: user.id }

      before(:each) do
        get "/invitations/#{invitation_1.id},#{invitation_2.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json.size).to eq(2)}
      it { expect(@json['data'][0]['owner_id']).to eq(user.id) }
      it { expect(@json['data'][1]['owner_type']).to eq('User') }
    end

    context 'with code' do
      let!(:invitation_1) { create :invitation, owner_type: user.class.name, owner_id: user.id }
      let!(:invitation_2) { create :invitation, owner_type: user.class.name, owner_id: user.id }
      before(:each) do
        get "/invitations/", {code: invitation_1.code}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1) }
      it { expect(@json['data'][0]['id']).to eq(invitation_1.id) }
    end

    context 'with owner_type && owner_id' do
      let(:group) { create :group }
      let!(:invitation_1) { create :invitation, owner_type: group.class.name, owner_id: group.id }
      let!(:invitation_2) { create :invitation, owner_type: user.class.name, owner_id: user.id }
      before(:each) do
        get "/invitations/", {owner_id: group.id, owner_type: group.class.name }, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1) }
      it { expect(@json['data'][0]['id']).to eq(invitation_1.id) }
    end


    context 'with owner_ids' do
      let(:group) { create :group }
      let!(:invitation_1) { create :invitation, owner_type: group.class.name, owner_id: group.id }
      let!(:invitation_2) { create :invitation, owner_type: user.class.name, owner_id: user.id }
      before(:each) do
        get "/invitations/?owner_ids=#{group.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1) }
      it { expect(@json['data'][0]['id']).to eq(invitation_1.id) }
    end
  end

  describe 'GET #show' do
    context 'with found' do
      let!(:invitation) { create :invitation, owner_type: user.class.name, owner_id: user.id }
      before(:each) do
        get "/invitations/#{invitation.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['id']).to eq(invitation.id.to_s) }
      it { expect(@json['owner_id']).to eq(user.id) }
      it { expect(@json['owner_type']).to eq('User') }
      it { expect(@json['code']).to_not be_nil }

    end

    context 'with not found' do
      before(:each) do
        get '/invitations/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
      end

      it { expect(response.status).to  eq(404) }
    end
  end

  describe 'POST #create' do
    context 'with successful' do
      before(:each) do
        post '/invitations', { invitation: attributes_for(:invitation, owner_id: user.id, owner_type: user.class.name) }, accept
        @json = parse_json(response.body)
      end

      it { expect(response.status).to  eq(201) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:invitation) { create :invitation, owner_type: user.class.name, owner_id: user.id }
    it { expect{  delete "/invitations/#{invitation.id}", {}, accept }.to change(Invitation, :count).from(1).to(0) }
  end
end

require 'rails_helper'

RSpec.describe V1::RequestsController, :type => :request do
  let!(:user) { create :user }
  let!(:invitee) { create :user }
  let!(:group) { create :group }
  describe 'GET #index' do
    let!(:request) { create :request, invitee_id: invitee.id, resource_type: group.class.name, resource_id: group.id }
    before(:each) do
      get "/requests", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Hash)}
    it { expect(@json['data'].size).to eq(1)}

    context 'with ids' do
      let!(:request_1) { create :request, invitee_id: invitee.id, resource_type: group.class.name, resource_id: group.id }
      let!(:request_2) { create :request, invitee_id: invitee.id, resource_type: group.class.name, resource_id: group.id }

      before(:each) do
        get "/requests/#{request_1.id},#{request_2.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json.size).to eq(2)}
    end

    context 'with resource_type OR resource_id OR invitee_id' do
      let!(:invitee_1) { create :user }
      let!(:request_1) { create :request, invitee_id: invitee_1.id, resource_type: group.class.name, resource_id: group.id }
      before(:each) do
        get "/requests/", {resource_id: group.id, resource_type: group.class.name, invitee_id: invitee_1.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1) }
      it { expect(@json['data'][0]['id']).to eq(request_1.id) }
    end

  end

  describe 'GET #show' do
    context 'with found' do
      let!(:request) { create :request, invitee_id: invitee.id, resource_type: group.class.name, resource_id: group.id, user_id: user.id }
      before(:each) do
        get "/requests/#{request.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['id']).to eq(request.id.to_s) }
      it { expect(@json['resource_type']).to eq(group.class.name) }
      it { expect(@json['resource_id']).to eq(group.id) }
      it { expect(@json['invitee_id']).to eq(invitee.id) }
      it { expect(@json['user_id']).to  eq(user.id)}
    end

    context 'with not found' do
      before(:each) do
        get '/requests/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
      end

      it { expect(response.status).to  eq(404) }
    end
  end

  describe 'POST #create' do
    context 'with successful' do
      before(:each) do
        post '/requests', {request: attributes_for(:request, user_id: user.id, resource_id: group.id, resource_type: group.class.name) }, accept
        @json = parse_json(response.body)
      end

      it { expect(response.status).to  eq(201) }
      it { expect(@json['user_id']).to  eq(user.id)}
    end
  end

  describe 'DELETE #destroy' do
    let!(:request) { create :request, invitee_id: invitee.id, resource_type: group.class.name, resource_id: group.id, state: 'ok' }
    it { expect{  delete "/requests/#{request.id}", {}, accept }.to change(Request, :count).from(1).to(0) }
  end
end

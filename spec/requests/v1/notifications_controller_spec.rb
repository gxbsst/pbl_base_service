require 'rails_helper'

describe V1::NotificationsController do
  let(:owner) { create :pbl_project }
  let(:user) { create :user }
  describe 'GET #index' do
    let!(:notification_1) { create :notification, sender_type: owner.class.name, sender_id: owner.id, subject: 'title 1', content: 'content 1', user_id: user.id }
    let!(:notification_2) { create :notification, sender_type: owner.class.name, sender_id: owner.id, subject: 'title 2', content: 'content 2', user_id: user.id }

    context 'get notifications' do
      before(:each) do
        get '/notifications', {user_id: user.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(response.body).to have_json_type(Hash) }
      it { expect(@json['data'][0]['subject']).to eq('title 2') }
      it { expect(@json['data'][1]['subject']).to eq('title 1') }
    end

    context 'with page' do
      before(:each) do
        get 'notifications?page=1&limit=1', {sender_type: owner.class.name, sender_id: owner.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['meta']['total_pages']).to eq(2)}
      it { expect(@json['meta']['current_page']).to eq(1)}
      it { expect(@json['meta']['per_page']).to eq('1')}
    end

    context 'with user_id' do
      let(:user_1) { create :user }
      let!(:notification_1) { create :notification, sender_type: owner.class.name, sender_id: owner.id, subject: 'title 1', content: 'content 1', user_id: user_1.id }
      let!(:notification_2) { create :notification, sender_type: owner.class.name, sender_id: owner.id, subject: 'title 2', content: 'content 2', user_id: user_1.id }
      let!(:notification_3) { create :notification, sender_type: owner.class.name, sender_id: owner.id, subject: 'title 2', content: 'content 2', user_id: user.id }
      before(:each) do
        get 'notifications', {user_id: user_1.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(2)}
    end

  end

  describe 'GET #show' do
    context 'with found' do
      let!(:notification) { create :notification, sender_type: owner.class.name, sender_id: owner.id, subject: 'title 2', content: 'content 2', user_id: user.id, additional_info: {a: 1} }
      before(:each) do
        get "/notifications/#{notification.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['id']).to eq(notification.id.to_s) }
      it { expect(@json['subject']).to eq('title 2') }
      it { expect(@json['content']).to eq('content 2') }
      it { expect(@json['read']).to be_falsey }
      it { expect(@json['global']).to be_falsey }
      it { expect(@json['additional_info']).to eq({"a" => "1"})}
      it { expect(@json['user_id']).to eq(user.id) }
      it { expect(@json['sender_type']).to eq(owner.class.name) }
      it { expect(@json['sender_id']).to eq(owner.id) }
    end

    context 'with not found' do
      before(:each) do
        get '/notifications/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
      end

      it { expect(response.status).to  eq(404) }
    end
  end

  describe 'POST #create' do
    context 'with successful' do
      before(:each) do
        post '/notifications', { notification: attributes_for(:notification, additional_info: {a: 1}, sender_id: owner.id, sender_type: owner.class.name, user_id: user.id) }, accept
        @json = parse_json(response.body)
      end

      it { expect(response.status).to  eq(201) }
      it { expect(@json['user_id']).to eq(user.id) }
      it { expect(@json['sender_type']).to eq(owner.class.name) }
      it { expect(@json['sender_id']).to eq(owner.id) }
      it { expect(@json['additional_info']).to eq({"a" => "1"})}
    end
  end

  describe 'DELETE #destroy' do
    let!(:notification) { create :notification, sender_type: owner.class.name, sender_id: owner.id, subject: 'title 2', content: 'content 2', user_id: user.id, additional_info: {a: 1} }
    it { expect{  delete "/notifications/#{notification.id}", {}, accept }.to change(Notification, :count).from(1).to(0) }
  end

  describe 'get #count' do
    let!(:notification_1) { create :notification, sender_type: owner.class.name, sender_id: owner.id, subject: 'title 2', content: 'content 2', user_id: user.id, additional_info: {a: 1} }
    let!(:notification_2) { create :notification, sender_type: owner.class.name, sender_id: owner.id, subject: 'title 2', content: 'content 2', user_id: user.id, additional_info: {a: 1}, type: 'S' }
    before(:each) do
      notification_2.update_attribute(:read, true)
      get '/notifications/count', {}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['count']).to eq(1)}

    it 'get not read' do
      get '/notifications/count', {type: 'S'}, accept
      @json = parse_json(response.body)

      expect(@json['count']).to eq(1)
    end
  end
end
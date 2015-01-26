require 'rails_helper'

RSpec.describe V1::Feed::MessagesController, :type => :request do

  let(:owner) { create :group }
  let(:sender) { create :user }
  let(:resource) { create :resource }
  let!(:post_0) { create :feeds_post, owner_id: owner.id, owner_type: owner.class.name, sender_id: sender.id, user_id: sender.id, title: 'title', content: 'content', resource_id: resource.id }
  let(:user) { create :user }
  describe 'GET #index' do
    let!(:message) { create :feeds_message,  user_id: user.id, post_id: post_0.id }

    context 'get index' do
      before(:each) do
        get '/feed/messages', {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1) }
    end

    context 'get index with user_id' do
      let(:user_1) { create :user }
      let!(:message_1) { create :feeds_message,  user_id: user_1.id, post_id: post.id }
      before(:each) do
        get '/feed/messages', {user_id: user_1.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1) }
    end

  end

  describe 'POST #create' do
    let!(:params) { attributes_for :feeds_message,  user_id: user.id, post_id: post_0.id }
    before(:each) do
      post '/feed/messages', {message: params}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['post_id']).to eq(post_0.id) }
  end

  describe 'GET #show' do
    let!(:message) { create :feeds_message,  user_id: user.id, post_id: post_0.id }
    before(:each) do
      get "/feed/messages/#{message.id}", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(message.id)}
    it { expect(@json['sender_id']).to eq(sender.id) }
    it { expect(@json['post_id']).to eq(post_0.id) }
    it { expect(@json['post']['id']).to eq(post_0.id) }
    it { expect(@json['post']['title']).to eq(post_0.title) }
    it { expect(@json['post']['content']).to eq(post_0.content) }
  end

  describe 'DELETE #destroy' do
    let!(:message) { create :feeds_message,  user_id: user.id, post_id: post_0.id }
    it { expect{  delete "/feed/messages/#{message.id}", {}, accept }.to change(Feeds::Message, :count).from(1).to(0) }
  end
end

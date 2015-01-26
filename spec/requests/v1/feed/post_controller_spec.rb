require 'rails_helper'

RSpec.describe V1::Feed::PostsController, :type => :request do

  let(:owner) { create :group }
  let(:sender) { create :user }
  let(:resource) { create :resource }

  describe 'GET #index' do
    let!(:post) { create :feeds_post, owner_id: owner.id, owner_type: owner.class.name, sender_id: sender.id, user_id: sender.id, title: 'title', content: 'content', resource_id: resource.id }

    context 'get index' do
      before(:each) do
        get '/feed/posts', {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1) }
    end

    context 'get index with owner_type || owner_id' do
      let(:owner_1) { create :user }
      let!(:post_1) { create :feeds_post, owner_id: owner_1.id, owner_type: owner_1.class.name, sender_id: sender.id, user_id: sender.id, title: 'title', content: 'content', resource_id: resource.id }
      before(:each) do
        get '/feed/posts', {owner_type: owner_1.class.name , owner_id: owner_1.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1) }
    end
  end

  describe 'POST #create' do
    let!(:params) { attributes_for :feeds_post, owner_id: owner.id, owner_type: owner.class.name, sender_id: sender.id, user_id: sender.id, title: 'title', content: 'content', resource_id: resource.id }
    before(:each) do
     post '/feed/posts', {post: params}, accept
     @json = parse_json(response.body)
    end

    it { expect(@json['title']).to eq('title') }
  end

  describe 'GET #show' do
    let!(:post) { create :feeds_post, owner_id: owner.id, owner_type: owner.class.name, sender_id: sender.id, user_id: sender.id, title: 'title', content: 'content', resource_id: resource.id }
    before(:each) do
      get "/feed/posts/#{post.id}", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['title']).to eq('title') }
    it { expect(@json['content']).to eq('content') }
    it { expect(@json['owner_type']).to eq(owner.class.name) }
    it { expect(@json['owner_id']).to eq(owner.id) }
    it { expect(@json['sender_id']).to eq(sender.id) }
    it { expect(@json['user_id']).to eq(sender.id) }
    it { expect(@json['resource_id']).to eq(resource.id)}
    # it { expect(@json['no']).to eq(1) }
    it { expect(@json['like_count']).to eq(1) }
  end

  describe 'DELETE #destroy' do
    let!(:post) { create :feeds_post, owner_id: owner.id, owner_type: owner.class.name, sender_id: sender.id, user_id: sender.id, title: 'title', content: 'content', resource_id: resource.id }
    it { expect{  delete "/feed/posts/#{post.id}", {}, accept }.to change(Feeds::Post, :count).from(1).to(0) }
  end
end

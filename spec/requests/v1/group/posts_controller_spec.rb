require 'rails_helper'

describe V1::Group::PostsController do

  let(:group) { create :group }
  let(:creator) { create :user }
  describe 'GET #index' do
    let!(:post_1) { create :post, group_id: group.id, user_id: creator.id, subject: 'subject 1', body: 'body'}
    let!(:post_2) { create :post, group_id: group.id, user_id: creator.id, subject: 'subject 2', body: 'body'}

    context 'get posts' do
      before(:each) do
        get '/group/posts', {group_id: group.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(response.body).to have_json_type(Hash) }
      it { expect(Groups::Post.count).to eq(2)}
      it { expect(assigns(:collections).size).to eq(2)}
      it { expect(@json['data'][0]['subject']).to eq('subject 2') }
      it { expect(@json['data'][1]['subject']).to eq('subject 1') }
    end

    context 'with page' do
      before(:each) do
        get 'group/posts?page=1&limit=1', {group_id: group.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['meta']['total_pages']).to eq(2)}
      it { expect(@json['meta']['current_page']).to eq(1)}
      it { expect(@json['meta']['per_page']).to eq('1')}
    end

    context 'with user_id' do
      let(:jim) { create :user }
      let!(:post_1) { create :post, group_id: group.id, user_id: creator.id, subject: 'subject 1', body: 'body'}
      let!(:post_2) { create :post, group_id: group.id, user_id: creator.id, subject: 'subject 2', body: 'body'}
      let!(:post_3) { create :post, group_id: group.id, user_id: jim.id,     subject: 'subject 3', body: 'body'}
      before(:each) do
        get 'group/posts', {user_id: creator.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(2)}
    end

  end

  describe 'GET #show' do
    context 'with found' do
      let!(:post) { create :post, group_id: group.id, user_id: creator.id, subject: 'subject 1', body: 'body'}
      before(:each) do
        get "/group/posts/#{post.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['id']).to eq(post.id) }
      it { expect(@json['subject']).to eq('subject 1') }
      it { expect(@json['body']).to eq('body') }
      it { expect(@json['likes_count']).to  eq(0)}
      it { expect(@json['forwardeds_count']).to  eq(0)}
      it { expect(@json['user_id']).to eq(creator.id) }
    end

    context 'with include replies' do
      let!(:post) { create :post_with_replies, group_id: group.id, user_id: creator.id, replies_count: 5}
      before(:each) do
        get "/group/posts/#{post.id}", {include: 'replies'}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['replies'].count).to eq(5)}

    end

    context 'with not found' do
      before(:each) do
        get '/group/posts/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
      end

      it { expect(response.status).to  eq(404) }
    end
  end

  describe 'POST #create' do
    context 'with successful' do
      before(:each) do
        post '/group/posts', {post: attributes_for(:post, user_id: creator.id, subject: 'subject', body: 'body', group_id: group.id) }, accept
        @json = parse_json(response.body)
      end

      it { expect(response.status).to  eq(201) }
      it { expect(@json['user_id']).to eq(creator.id) }
      it { expect(@json['group_id']).to eq(group.id) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:post) { create :post, group_id: group.id, user_id: creator.id, subject: 'subject 1', body: 'body'}
    it { expect{  delete "/group/posts/#{post.id}", {}, accept }.to change(Groups::Post, :count).from(1).to(0) }
  end

end
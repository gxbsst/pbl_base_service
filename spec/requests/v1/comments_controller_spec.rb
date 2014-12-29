require 'rails_helper'

describe V1::CommentsController do
  let(:owner) { create :pbl_project }
  describe 'GET #index' do
    let!(:comment_1) { create :comment, commentable_type: owner.class.name, commentable_id: owner.id, title: 'title 1', comment: 'comment 2' }
    let!(:comment_2) { create :comment, commentable_type: owner.class.name, commentable_id: owner.id, title: 'title 2', comment: 'comment 2' }

    context 'get comments' do
      before(:each) do
        get '/comments', {commentable_type: owner.class.name, commentable_id: owner.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(response.body).to have_json_type(Hash) }
      it { expect(@json['data'][0]['title']).to eq('title 2') }
      it { expect(@json['data'][1]['title']).to eq('title 1') }
    end

    context 'with  owner_type and owner_id' do
      let(:owner) { create :pbl_project }
      let!(:comment) { create :comment, commentable_type: 'project', commentable_id: owner.id, title: 'title 1', comment: 'comment 2' }
      before(:each) do
        get "/comments/", {commentable_type: "project", commentable_id: owner.id}, accept
        @json = parse_json(response.body)
      end
      it { expect(@json['data'].size).to eq(1) }
    end

    context 'with  owner_type and owner_ids' do
      let(:owner_1) { create :pbl_project }
      let(:owner_2) { create :pbl_project }
      let!(:resource_1)  { create :comment, commentable_type: 'project_product', commentable_id: owner_1.id, title: 'name 1' }
      let!(:resource_2)  { create :comment, commentable_type: 'project_product', commentable_id: owner_2.id, title: 'name 1' }
      let!(:resource_3)  { create :comment, commentable_type: 'project_product' }
      before(:each) do
        get "/comments/", {commentable_type: 'project_product', commentable_ids: "#{owner_1.id},#{owner_2.id}"}, accept
        @json = parse_json(response.body)
      end
      it { expect(@json['data'].size).to eq(2) }
    end

    context 'with  owner_types and owner_ids' do
      let(:owner_1) { create :pbl_project }
      let(:owner_2) { create :pbl_project }
      let!(:owner_3) { create :pbl_product }
      let!(:resource_1)  { create :comment, commentable_type: 'project_product', commentable_id: owner_1.id, title: 'name 1' }
      let!(:resource_2)  { create :comment, commentable_type: 'project_product', commentable_id: owner_2.id, title: 'name 1' }
      let!(:resource_3)  { create :comment,  commentable_type: 'product', commentable_id: owner_3.id, title: 'name 1'  }
      let!(:resource_4)  { create :resource, owner_type: 'project_product' }
      before(:each) do
        get "/comments/", {commentable_types: 'project_product,product', commentable_ids: "#{owner_1.id},#{owner_2.id},#{owner_3.id}"}, accept
        @json = parse_json(response.body)
      end
      it { expect(@json['data'].size).to eq(3) }
    end

    context 'with page' do
      before(:each) do
        get 'comments?page=1&limit=1', {commentable_type: owner.class.name, commentable_id: owner.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['meta']['total_pages']).to eq(2)}
      it { expect(@json['meta']['current_page']).to eq(1)}
      it { expect(@json['meta']['per_page']).to eq('1')}
    end

    context 'with include commentable ' do
      before(:each) do
        get 'comments?include=commentable', {commentable_type: owner.class.name, commentable_id: owner.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'][0]['commentable']).to be_a Array }
      it { expect(@json['data'][0]['commentable'][0]['commentable_type']).to eq(owner.class.name) }
      it { expect(@json['data'][0]['commentable'][0]['commentable_id']).to eq(owner.id) }
    end
  end

  describe 'GET #show' do
    context 'with found' do
      let!(:comment)  { create :comment, commentable_type: owner.class.name, commentable_id: owner.id, title: 'name 1' }
      before(:each) do
        get "/comments/#{comment.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['id']).to eq(comment.id.to_s) }
      it { expect(@json['title']).to eq('name 1') }
      it { expect(@json['commentable_id']).to_not be_nil }
      it { expect(@json['commentable_type']).to eq(owner.class.name) }
      it { expect(@json['comment']).to eq('comment') }
    end

    context 'with not found' do
      before(:each) do
        get '/comments/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
      end

      it { expect(response.status).to  eq(404) }
    end
  end

  describe 'POST #create' do
    context 'with successful' do
      before(:each) do
        post '/comments', { comment: attributes_for(:comment, commentable_id: owner.id, commentable_type: owner.class.name) }, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['title']).to eq('title') }
      it { expect(@json['comment']).to eq('comment') }
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment)  { create :comment, commentable_type: owner.class.name, commentable_id: owner.id, title: 'name 1' }
    it { expect{  delete "/comments/#{comment.id}", {}, accept }.to change(Comment, :count).from(1).to(0) }
  end
end
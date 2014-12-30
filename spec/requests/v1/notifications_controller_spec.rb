require 'rails_helper'

describe V1::NotificationsController do
  let(:owner) { create :pbl_project }
  let(:user) { create :user }
  describe 'GET #index' do
    let!(:notification_1) { create :notification, sender_type: owner.class.name, sender_id: owner.id, subject: 'title 1', body: 'body 1', user_id: user.id }
    let!(:notification_2) { create :notification, sender_type: owner.class.name, sender_id: owner.id, subject: 'title 2', body: 'body 2', user_id: user.id }

    context 'get comments' do
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
        get 'comments?page=1&limit=1', {commentable_type: owner.class.name, commentable_id: owner.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['meta']['total_pages']).to eq(2)}
      it { expect(@json['meta']['current_page']).to eq(1)}
      it { expect(@json['meta']['per_page']).to eq('1')}
    end

  end

  # describe 'GET #show' do
  #   context 'with found' do
  #     let!(:comment)  { create :comment, commentable_type: owner.class.name, commentable_id: owner.id, title: 'name 1' }
  #     before(:each) do
  #       get "/comments/#{comment.id}", {}, accept
  #       @json = parse_json(response.body)
  #     end
  #
  #     it { expect(@json['id']).to eq(comment.id.to_s) }
  #     it { expect(@json['title']).to eq('name 1') }
  #     it { expect(@json['commentable_id']).to_not be_nil }
  #     it { expect(@json['commentable_type']).to eq(owner.class.name) }
  #     it { expect(@json['comment']).to eq('comment') }
  #   end
  #
  #   context 'with not found' do
  #     before(:each) do
  #       get '/comments/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
  #     end
  #
  #     it { expect(response.status).to  eq(404) }
  #   end
  # end
  #
  # describe 'POST #create' do
  #   context 'with successful' do
  #     before(:each) do
  #       post '/comments', { comment: attributes_for(:comment, commentable_id: owner.id, commentable_type: owner.class.name) }, accept
  #       @json = parse_json(response.body)
  #     end
  #
  #     it { expect(@json['title']).to eq('title') }
  #     it { expect(@json['comment']).to eq('comment') }
  #   end
  # end
  #
  # describe 'DELETE #destroy' do
  #   let!(:comment)  { create :comment, commentable_type: owner.class.name, commentable_id: owner.id, title: 'name 1' }
  #   it { expect{  delete "/comments/#{comment.id}", {}, accept }.to change(Comment, :count).from(1).to(0) }
  # end
end
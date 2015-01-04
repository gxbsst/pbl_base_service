require 'rails_helper'

describe V1::Pbl::DiscussionsController do
  let(:user) { create :user }
  let(:project) { create :pbl_project,  user_id: user.id }

  describe 'GET #index' do
    let!(:discussion_1) { create :pbl_discussion_with_members, project_id: project.id, name: 'name', uid: 'uid' }
    let!(:discussion_2) { create :pbl_discussion_with_members, project_id: project.id, name: 'name', uid: 'uid' }
    before(:each) do
      get 'pbl/discussions', { project_id: project.id}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['data'].size).to eq(2)}
    it { expect(@json['data'][0]['members']).to be_a Array }
    it { expect(@json['data'][0]['members']).to match_array(discussion_2.discussion_members.collect(&:user_id)) }
    it { expect(@json['data'][1]['members']).to match_array(discussion_1.discussion_members.collect(&:user_id)) }
  end

  describe 'POST #create' do
    context 'create one discussion' do
      before(:each) do
        post 'pbl/discussions', { discussion: {name: 'name', uid: 1, project_id: project.id, members: [user.id]}}, accept
        @json = parse_json(response.body)
      end

      it { expect(Pbls::Discussion.count).to eq(1)}
      it { expect(response.status).to eq(201)}
    end

    context 'create many discussions' do
      let(:user_1) { create :user }
      let(:user_2) { create :user }
      let(:params) {
        [
            {name: 'name', uid: 1, project_id: project.id, members: [user_1.id, user_2.id]},
            {name: 'name', uid: 2, project_id: project.id, members: [user_1.id, user_2.id]}
        ]
      }
      before(:each) do
        post 'pbl/discussions', { discussion: params}, accept
        @json = parse_json(response.body)
      end

      it { expect(Pbls::Discussion.count).to eq(2)}
      it { expect(Pbls::DiscussionMember.count).to eq(4)}
    end
  end

  describe 'PATCH #update' do
    let!(:discussion) { create :pbl_discussion_with_members, project_id: project.id, members_count: 5}
    context 'update one discussion' do
      let(:user) { create :user}
      let(:params){
        {
            name: 'update name'
        }
      }
      before(:each) do
        patch "pbl/discussions/#{discussion.id}", {discussion: params}, accept
        @json = parse_json(response.body)
      end

      it 'update the discussion' do
        discussion.reload
        expect(discussion.name).to eq('update name')
      end
    end
  end


  describe 'DELETE #destroy' do

    let!(:discussion) { create :pbl_discussion, project_id: project.id}
    before(:each) do
      delete "/pbl/discussions/#{discussion.id}", {}, accept
    end

    it { expect(Pbls::Discussion.count).to eq(0)}
  end

  describe 'GET #show' do
    let!(:discussion) { create :pbl_discussion, project_id: project.id}
    before(:each) do
      get "/pbl/discussions/#{discussion.id}", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(discussion.id)}
    it { expect(@json['name']).to eq(discussion.name)}
    it { expect(@json['project_id']).to eq(discussion.project_id)}
  end
end
require 'rails_helper'

describe V1::Pbl::DiscussionsController do
  let(:user) { create :user }
  let(:project) { create :pbl_project,  user_id: user.id }

  describe 'GET #index' do
    let!(:discussion_1) { create :pbl_discussion, project_id: project.id, name: 'name', uid: 'uid' }
    let!(:discussion_2) { create :pbl_discussion, project_id: project.id, name: 'name', uid: 'uid' }
    before(:each) do
      get 'pbl/discussions', { project_id: project.id}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['data'].size).to eq(2)}
  end

  describe 'POST #create' do
    context 'create a discussion' do
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
end
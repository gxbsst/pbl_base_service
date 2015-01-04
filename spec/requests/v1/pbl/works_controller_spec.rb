require 'rails_helper'

describe V1::Pbl::WorksController do
  let(:project) { create :pbl_project }
  let(:user) { create :user }
  let(:task) { create :pbl_task, project_id: project.id }
  let(:group) { create :group }

  describe 'GET #index' do
    context 'get works with project_id' do
      let!(:work_1) { create :pbl_work, user_id: user.id, task_id: task.id, group_id: group.id, state: 'imcomplete'}
      let!(:work_2) { create :pbl_work, user_id: user.id, task_id: task.id, group_id: group.id, state: 'imcomplete'}
      before(:each) do
        get 'pbl/works', {task_id: task.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(2) }
    end

    context 'get works with task_id'
    context 'get works with user_id'
    context 'get works with assignee_id'

  end
end
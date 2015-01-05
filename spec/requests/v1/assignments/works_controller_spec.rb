require 'rails_helper'

describe V1::Assignment::WorksController do
  let(:task) { create :pbl_task }
  let(:acceptor) { create :user }
  let(:sender) { create :user }
  let(:listener) { double.as_null_object }

  describe 'GET #index' do
    context 'get works with ids' do
      let!(:work_1) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      let!(:work_2) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      let!(:work_3) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      before(:each) do
        get "assignment/works/#{work_1.id},#{work_2.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(2) }
    end

    context 'get works with task_id & task_type' do
      let(:project_task) { create :pbl_project }
      let!(:work_1) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      let!(:work_2) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      let!(:work_3) { create :assignments_work, task_id: project_task.id, task_type: project_task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      before(:each) do
        get "assignment/works/", {task_id: task.id, task_type: task.class.name}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(2) }
    end

    context 'get works with task_ids & task_types' do
      let(:project_task) { create :pbl_project }
      let(:fake_task) { create :user }
      let!(:work_1) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      let!(:work_2) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      let!(:work_3) { create :assignments_work, task_id: project_task.id, task_type: project_task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      let!(:work_4) { create :assignments_work, task_id: fake_task.id, task_type: fake_task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      before(:each) do
        get "assignment/works/", {task_ids: "#{task.id},#{project_task.id}", task_types: "#{task.class.name},#{project_task.class.name}"}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(3) }
    end

    context 'get works with user_id'
    context 'get works with assignee_id'

  end
end
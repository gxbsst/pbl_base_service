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

    context 'get works with acceptor_id & acceptor_type' do
      let(:project_task) { create :pbl_project }
      let(:acceptor_1) { create :user}
      let(:fake_task) { create :user }
      let!(:work_1) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor_1.id, acceptor_type: acceptor_1.class.name, sender_id: sender.id }
      let!(:work_2) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor_1.id, acceptor_type: acceptor_1.class.name, sender_id: sender.id }
      let!(:work_3) { create :assignments_work, task_id: project_task.id, task_type: project_task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      let!(:work_4) { create :assignments_work, task_id: fake_task.id, task_type: fake_task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      before(:each) do
        get "assignment/works/", {acceptor_id: "#{acceptor_1.id}", acceptor_type: "#{acceptor_1.class.name}"}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(2) }

    end

    context 'get works with project_id' do
      let(:project) { create :pbl_project }
      let(:task) { create :pbl_task, project_id: project.id }
      let(:project_task) { create :pbl_project }
      let(:fake_task) { create :user }
      let!(:work_1) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      let!(:work_2) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      let!(:work_3) { create :assignments_work, task_id: project_task.id, task_type: project_task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      let!(:work_4) { create :assignments_work, task_id: fake_task.id, task_type: fake_task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      before(:each) do
        get "assignment/works/", {project_id: "#{project.id}"}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(2) }
    end

    context 'get works with include scores' do
      let(:project) { create :pbl_project }
      let(:task) { create :pbl_task, project_id: project.id }
      let!(:work) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      before(:each) do
        work.do_open
        work.work
        work.submit
        work.scores.create(comment: 'comment', score: 10)
        get "assignment/works/", {include: "scores"}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'][0]['scores']).to be_a Array }
      it { expect(@json['data'][0]['scores'][0]['comment']).to eq('comment') }
      it { expect(@json['data'][0]['scores'][0]['score']).to eq(10) }
    end

    context 'with state' do
      let!(:work_1) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      let!(:work_2) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      before(:each) do
        work_1.do_open
        work_2.do_open
        work_2.work
      end
      context 'with open' do
        before(:each) do
          get "assignment/works/", {state: "opening"}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['data'].size).to eq(1)}
      end

      context 'with working' do
        before(:each) do
          get "assignment/works/", {state: "working"}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['data'].size).to eq(1)}
      end

    end
  end

  describe 'POST #create' do
    let(:params)  {
      {
          task_id: task.id,
          task_type: task.class.name,
          acceptor_id: acceptor.id,
          acceptor_type: acceptor.class.name,
          sender_id: sender.id
      }
    }
    before(:each) do
      post "assignment/works/", {work: params}, accept
      @json = parse_json(response.body)
    end

    it { expect(Assignments::Work.count).to eq(1)}
  end

  describe 'PATCH #update' do
    context 'with normal update' do
      let(:resource) { create :resource }
      let!(:work) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
      before(:each) do
        patch "assignment/works/#{work.id}", { work: {content: 'content', resource_id: resource.id}}, accept
        @json = parse_json(response.body)
      end

      it 'submit a work' do
        work.reload
        expect(@json['content']).to eq('content')
        expect(@json['resource_id']).to eq(resource.id)
      end
    end

    context 'with state' do
      let(:resource) { create :resource }
      let!(:work) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }

      context 'with working' do
        before(:each) do
          work.do_open
          patch "assignment/works/#{work.id}", { work: {state: 'working'}}, accept
          @json = parse_json(response.body)
        end

        it 'submit a work' do
          work.reload
          expect(@json['state']).to eq('working')
          expect(@json['submit_at']).to be_nil
        end
      end

      context 'with submited' do
        before(:each) do
          work.do_open
          work.work
          patch "assignment/works/#{work.id}", { work: {state: 'submitted'}}, accept
          @json = parse_json(response.body)
        end

        it 'submit a submitted' do
          work.reload
          expect(@json['state']).to eq('submitted')
          expect(@json['submit_at']).to_not be_nil
        end
      end
    end
  end

  describe 'GET #show' do
    let(:project) { create :pbl_project }
    let(:task) { create :pbl_task, project_id: project.id }
    let!(:work) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }
    before(:each) do
      work.do_open
      work.work
      work.submit
      work.scores.create(comment: 'comment', score: 10)
      get "assignment/works/#{work.id}", {include: "scores"}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['scores']).to be_a Array }
    it { expect(@json['scores'][0]['comment']).to eq('comment') }
    it { expect(@json['scores'][0]['score']).to eq(10) }
  end
end
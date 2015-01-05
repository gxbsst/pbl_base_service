require 'rails_helper'

describe V1::Assignment::ScoresController do
  let(:task) { create :pbl_task }
  let(:acceptor) { create :user }
  let(:sender) { create :user }
  let!(:work) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id, state: 'submitted' }
  let!(:work_1) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id, state: 'submitted' }

  describe 'GET #index' do

    let!(:score_1) { create :assignments_score, work_id: work.id, comment: 'comment', score: 10 }
    let!(:score_3) { create :assignments_score, work_id: work_1.id, comment: 'comment', score: 10 }

    context 'with normal' do
      before(:each) do
        get 'assignment/scores', {}, accept
        @json = parse_json(response.body)
      end

      it { expect(Assignments::Score.count).to eq(2)}
      it { expect(@json['data'].size).to eq(2) }
    end

    context 'with work_id' do
      before(:each) do
        get 'assignment/scores', {work_id: work.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1) }
    end
  end

  describe "POST #create" do
    let(:params) {
      {
          work_id: work.id,
          comment: 'comment',
          score: 10
      }
    }

    context 'with state of work is open' do
      before(:each) do
        post 'assignment/scores', {score: params}, accept
        @json = parse_json(response.body)
      end

      it 'create a score' do
        expect(Assignments::Score.count).to eq(0)
      end
    end

    context 'with state of work is working' do
      before(:each) do
        work.do_open
        post 'assignment/scores', {score: params}, accept
        @json = parse_json(response.body)
      end

      it 'create a score' do
        expect(Assignments::Score.count).to eq(0)
      end
    end

    context 'with state of work is submitted' do
      before(:each) do
        work.do_open
        work.work
        work.submit
        post 'assignment/scores', {score: params}, accept
        @json = parse_json(response.body)
      end

      it 'create a score' do
        work.reload
        expect(Assignments::Score.count).to eq(1)
        expect(work.state).to eq('evaluated')
      end
    end
  end
end
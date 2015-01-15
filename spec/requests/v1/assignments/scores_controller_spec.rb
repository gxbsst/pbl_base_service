require 'rails_helper'

describe V1::Assignment::ScoresController do
  let(:task) { create :pbl_task }
  let(:acceptor) { create :user }
  let(:sender) { create :user }
  let!(:work) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id, state: 'evaluating' }
  let!(:work_1) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id, state: 'evaluating' }

  describe 'GET #index' do

    let(:user) { create :user }
    let!(:score_1) { create :assignments_score, owner_id: work.id, owner_type: 'Assignments::Work',  comment: 'comment', score: 10}
    let!(:score_3) { create :assignments_score, owner_id: work_1.id, owner_type: 'Assignments::Work', comment: 'comment', score: 10 }

    context 'with normal' do
      before(:each) do
        get 'assignment/scores', {}, accept
        @json = parse_json(response.body)
      end

      it { expect(Assignments::Score.count).to eq(2)}
      it { expect(@json['data'].size).to eq(2) }
    end

    context 'with owner_id and owner_type' do
      before(:each) do
        get 'assignment/scores', {owner_id: work.id, owner_type: 'Assignments::Work'}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1) }
    end

    context 'with owner_id and owner_type and user_id' do
      let!(:work_2) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id, state: 'evaluating' }
      let!(:score_5) { create :assignments_score, owner_id: work_2.id, owner_type: 'Assignments::Work', comment: 'comment', score: 10, user_id: user.id }
      before(:each) do
        get 'assignment/scores', {owner_id: work_2.id, owner_type: 'Assignments::Work', user_id:user.id }, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1) }
    end

  end

  describe "POST #create" do
    let!(:work) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id, state: 'opening' }
    let(:params) {
      {
          owner_id: work.id,
          owner_type: work.class.name,
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

      let!(:work) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id, state: 'working' }
      let(:params) {
        {
            owner_id: work.id,
            owner_type: work.class.name,
            comment: 'comment',
            score: 10
        }
      }
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
        work.evaluating
        post 'assignment/scores', {score: params}, accept
        @json = parse_json(response.body)
      end

      it 'create a score' do
        work.reload
        expect(Assignments::Score.count).to eq(1)
        expect(work.state).to eq('evaluated')
      end
    end

    context 'with array' do
      let!(:work) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id, state: 'evaluating' }
      let!(:gauge) { create :gauge }
      let(:params) {
        [
            {
                owner_id: work.id,
                owner_type: work.class.name,
                comment: 'comment',
                score: 10
            },
            {
                owner_id: gauge.id,
                owner_type: 'Abc',
                comment: 'comment 2',
                score: 12
            }
        ]
      }
      before(:each) do
        work.submit
        post 'assignment/scores', {score: params}, accept
        @json = parse_json(response.body)
      end

     it { expect(Assignments::Score.count).to eq(2)}
    end
  end
end
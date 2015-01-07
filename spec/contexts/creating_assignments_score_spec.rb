require 'rails_helper'

describe CreatingAssignmentsScore do
  describe '.create' do
    let(:task) { create :pbl_task }
    let(:acceptor) { create :user }
    let(:sender) { create :user }
    let!(:work) { create :assignments_work, task_id: task.id, task_type: task.class.name, acceptor_id: acceptor.id, acceptor_type: acceptor.class.name, sender_id: sender.id }

    let(:listener) { double.as_null_object }

    context 'create a work' do
      let(:params) {
        {
            score: {
                owner_id: work.id,
                owner_type: work.class.name,
                score: 10,
                comment: 'comment'
            }
        }
      }
      before(:each) do
        work.do_open
        work.work
        work.submit
        expect(listener).to receive(:on_create_success)
      end
      it "create a score" do
        described_class.create(listener, params[:score])
        expect(Assignments::Score.count).to eq(1)
      end
    end

    context 'create many scores' do
      let(:gauge) { create :gauge }
      let(:params) {
        {
            score: [
                {
                    owner_id: work.id,
                    owner_type: work.class.name,
                    comment: 'comment',
                    score: 10
                },
                {
                    owner_id: gauge.id,
                    owner_type: gauge.class.name,
                    comment: 'comment 2',
                    score: 12
                }
            ]
        }
      }
      before(:each) do
        work.do_open
        work.work
        work.submit
        expect(listener).to receive(:on_create_success)
      end
      it "create many works" do
        described_class.create(listener, params[:score])
        expect(Assignments::Score.count).to eq(2)
      end
    end
  end
end
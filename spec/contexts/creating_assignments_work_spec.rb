require 'rails_helper'

describe CreatingAssignmentsWork do
  describe '.create' do
    let(:task) { create :pbl_task }
    let(:acceptor) { create :user }
    let(:sender) { create :user }
    let(:listener) { double.as_null_object }

    context 'create a work' do
      let(:params) {
        {
            work: {
                task_id: task.id,
                task_type: task.class.name,
                sender_id: sender.id,
                acceptor_id: acceptor.id,
                acceptor_type: acceptor.class.name
            }
        }
      }
      before(:each) do
        expect(listener).to receive(:on_create_success)
      end
      it "create a discussion" do
        described_class.create(listener, params[:work])
        expect(Assignments::Work.count).to eq(1)
      end
    end

    context 'create many works' do
      let(:params) {
        {
            work: [
                {
                    task_id: task.id,
                    task_type: task.class.name,
                    sender_id: sender.id,
                    acceptor_id: acceptor.id,
                    acceptor_type: acceptor.class.name
                },
                {
                    task_id: task.id,
                    task_type: task.class.name,
                    sender_id: sender.id,
                    acceptor_id: acceptor.id,
                    acceptor_type: acceptor.class.name
                }
            ]
        }
      }
      before(:each) do
        expect(listener).to receive(:on_create_success)
      end
      it "create many works" do
        described_class.create(listener, params[:work])
        expect(Assignments::Work.count).to eq(2)
      end
    end
  end
end
require 'rails_helper'

describe CreatingPblDiscussion do
  describe '.create' do
    let(:user_1) { create :user }
    let(:user_2) { create :user }
    let(:project) { create :pbl_project}
    let(:listener) { double.as_null_object }

    context 'create a discussion' do
      let(:params) {
        {
            discussion: {
                name: 'name',
                no: 1,
                project_id: project.id,
                members: [user_1.id, user_2.id]
            }
        }
      }
      before(:each) do
        # expect(listener).to receive(:on_create_success)
      end
      it "create a discussion" do
        CreatingPblDiscussion.create(listener, params[:discussion])
        expect(Pbls::Discussion.count).to eq(1)
        expect(Pbls::DiscussionMember.count).to eq(2)
      end
    end


    context 'create many discussions' do
      let(:params) {
        {
            discussion: [
                {
                    name: 'name',
                    no: 1,
                    project_id: project.id,
                    members: [user_1.id, user_2.id]
                },
                {
                    name: 'name',
                    no: 1,
                    project_id: project.id,
                    members: [user_1.id, user_2.id]
                }
            ]
        }
      }
      before(:each) do
        expect(listener).to receive(:on_create_success)
      end
      it "create many discusstions" do
        CreatingPblDiscussion.create(listener, params[:discussion])
        expect(Pbls::Discussion.count).to eq(2)
        expect(Pbls::DiscussionMember.count).to eq(4)
      end
    end
  end
end
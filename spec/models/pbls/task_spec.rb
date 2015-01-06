require 'rails_helper'

RSpec.describe Pbls::Task, :type => :model do
  # it { expect(described_class.new).to validate_presence_of(:title) }
  it { expect(described_class.new).to belong_to(:project) }
  it { expect(described_class.new).to respond_to(:start_at) }
  it { expect(described_class.new).to respond_to(:submit_way) }
  it { expect(described_class.new).to respond_to(:final) }
  it { expect(described_class.new).to respond_to(:discussion_ids) }
  it { expect(described_class.new).to respond_to(:state) }

  let(:task) { described_class.new(description: 'task test 001') }
  it { expect(task.description).to eq('task test 001') }


  describe '#state' do
    let(:task) { create :pbl_task }
    it { expect(task.state).to eq('draft')}

    it 'release' do
      task.release
      task.reload
      expect(task.state).to eq('released')
    end
  end
end

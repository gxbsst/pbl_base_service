require 'rails_helper'

RSpec.describe Pbls::Task, :type => :model do
  # it { expect(described_class.new).to validate_presence_of(:title) }
  it { expect(described_class.new).to belong_to(:project) }

  let(:task) { described_class.new(description: 'task test 001') }
  it { expect(task.description).to eq('task test 001') }
  pending "add other cases"
end

require 'rails_helper'
describe Curriculums::Subject do
  it { expect(described_class.new).to have_many(:phases) }

  describe 'validate' do
    let(:subject) { described_class.new }

    it { expect(subject).to be_invalid }
    it { subject.valid?; expect(subject.errors[:name].size).to eq(1)}
  end
end
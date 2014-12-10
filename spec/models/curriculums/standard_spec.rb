require 'rails_helper'
describe Curriculums::Standard do
  it { expect(described_class.new).to belong_to(:phase) }
  it { expect(described_class.new).to have_many(:items) }

  describe 'validate' do
    let(:curriculum) { described_class.new }

    it { expect(curriculum).to be_invalid }
    it { curriculum.valid?; expect(curriculum.errors[:title].size).to eq(1)}
  end

  describe '.create' do
    let!(:subject) { Curriculums::Subject.create(name: 'name')}
    let!(:phase) { subject.phases.create(name: 'name')}

    it { expect(Curriculums::Standard.new(title: 'name', phase_id: phase.id.to_s)).to be_valid}
    it 'create a curriculum' do
      phase.standards.create(title: 'title')
      expect(Curriculums::Standard.count).to be(1)
    end
  end
end
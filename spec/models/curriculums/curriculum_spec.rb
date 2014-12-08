require 'rails_helper'
describe Curriculums::Curriculum do
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

    it { expect(Curriculums::Curriculum.new(title: 'name', phase_id: phase.id.to_s)).to be_valid}
    it 'create a curriculum' do
      phase.curriculums.create(title: 'title')
      expect(Curriculums::Curriculum.count).to be(1)
    end
  end
end
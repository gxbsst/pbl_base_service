require 'rails_helper'
describe Curriculums::CurriculumItem do
  it { expect(described_class.new).to belong_to(:curriculum) }

  describe 'validate' do
    let(:curriculum_item) { described_class.new }

    it { expect(curriculum_item).to be_invalid }
    it { curriculum_item.valid?; expect(curriculum_item.errors[:content].size).to eq(1)}
  end
end
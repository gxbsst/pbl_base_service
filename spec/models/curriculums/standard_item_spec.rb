require 'rails_helper'
describe Curriculums::StandardItem do
  it { expect(described_class.new).to belong_to(:standard) }
  it { expect(described_class.new).to respond_to(:is_category) }

  describe 'validate' do
    let(:curriculum_item) { described_class.new }

    it { expect(curriculum_item).to be_invalid }
    it { curriculum_item.valid?; expect(curriculum_item.errors[:content].size).to eq(1)}
  end
end
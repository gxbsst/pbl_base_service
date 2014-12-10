require 'rails_helper'
describe Skills::Category  do
  it { expect(described_class.new).to have_many(:sub_categories) }

  describe 'validate' do
    let(:category) { described_class.new }

    it { expect(category).to be_invalid }
    it { category.valid?; expect(category.errors[:name].size).to eq(1)}
  end
end
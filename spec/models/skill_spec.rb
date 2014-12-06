require 'rails_helper'
describe Skill  do
  it { expect(Skill.new).to have_many(:categories) }

  describe 'validate' do
    let(:skill) { Skill.new }

    it { expect(skill).to be_invalid }
    it { skill.valid?; expect(skill.errors[:title].size).to eq(1)}
  end
end
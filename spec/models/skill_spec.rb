require 'spec_helper'
require 'rails_helper'
describe Skill  do
  describe 'validate' do
    let(:skill) { Skill.new }

    it { expect(skill).to be_invalid }
    it { skill.valid?; expect(skill.errors[:title].size).to eq(1)}
  end
end
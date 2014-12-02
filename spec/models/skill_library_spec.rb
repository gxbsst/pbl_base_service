require 'spec_helper'
require 'rails_helper'
describe SkillLibrary  do
  before(:each) do
    s = SkillLibrary.new(:name => 'abc')
    s.save(:validate=> false)
  end
  it { expect(SkillLibrary.first.name).to eq('abc') }
end
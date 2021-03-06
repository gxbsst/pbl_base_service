require 'rails_helper'

RSpec.describe Pbls::Technique, :type => :model do
  it { expect(described_class.new).to belong_to(:project)}
  it { expect(described_class.new).to belong_to(:technique)}
end

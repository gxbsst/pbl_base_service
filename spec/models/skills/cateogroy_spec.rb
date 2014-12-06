require 'rails_helper'

describe Skills::Category do
  it { expect(described_class.new).to belong_to(:skill) }
  it { expect(described_class.new).to have_many(:techniques) }
  it { expect(described_class.new).to validate_presence_of(:name) }
end
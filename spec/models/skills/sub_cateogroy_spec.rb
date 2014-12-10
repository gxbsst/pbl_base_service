require 'rails_helper'

describe Skills::SubCategory do
  it { expect(described_class.new).to belong_to(:category) }
  it { expect(described_class.new).to have_many(:techniques) }
  it { expect(described_class.new).to validate_presence_of(:name) }
end
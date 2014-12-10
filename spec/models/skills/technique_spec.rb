require 'rails_helper'

describe Skills::Technique do
  it { expect(described_class.new).to belong_to(:sub_category) }
  it { expect(described_class.new).to validate_presence_of(:title) }
  it { expect(described_class.new).to respond_to(:description) }
end
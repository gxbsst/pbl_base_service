require 'rails_helper'

RSpec.describe Pbls::Knowledge, :type => :model do
  it { expect(described_class.new).to validate_presence_of(:description) }
  it { expect(described_class.new).to belong_to(:project) }

  let(:knowledge) { described_class.new(description: 'spring hibernate') }
  it { expect(knowledge.description).to eq('spring hibernate') }
end



require 'rails_helper'

RSpec.describe Pbls::Searcher, :type => :model do

  describe 'index subject and phase' do
    let!(:standard_item) { create :pbl_standard_item }

    it { expect(described_class.count).to eq(1) }
    it { expect(described_class.first.subject).to_not be_nil }
    it { expect(described_class.first.phase).to_not be_nil }
    it { expect(described_class.first.project_id).to_not be_nil }
  end

  describe 'index technique' do
    let!(:technique) { create :pbl_technique }

    it { expect(described_class.count).to eq(1) }
    it { expect(described_class.first.project_id).to_not be_nil }
    it { expect(described_class.first.technique).to_not be_nil }
  end
end

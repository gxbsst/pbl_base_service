require 'rails_helper'

RSpec.describe Pbls::Rule, :type => :model do
  it { expect(described_class.new).to belong_to(:technique) }
  it { expect(described_class.new).to belong_to(:project) }
  it { expect(described_class.new).to belong_to(:gauge) }

end

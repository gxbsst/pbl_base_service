require 'rails_helper'

RSpec.describe Gauge, :type => :model do
  it { expect(described_class.new).to validate_presence_of(:technique)}
end

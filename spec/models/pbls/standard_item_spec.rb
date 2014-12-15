require 'rails_helper'

RSpec.describe Pbls::StandardItem, :type => :model do
  it { expect(described_class.new).to belong_to(:project)}
  it { expect(described_class.new).to belong_to(:standard_item)}
end

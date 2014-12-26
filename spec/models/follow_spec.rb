require 'rails_helper'

RSpec.describe Follow, :type => :model do
  it { expect(described_class.new).to belong_to(:user)}
  it { expect(described_class.new).to belong_to(:follower)}
end

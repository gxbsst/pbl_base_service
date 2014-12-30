require 'rails_helper'

RSpec.describe Groups::Reply, :type => :model do
  it { expect(described_class.new).to belong_to(:user) }
  it { expect(described_class.new).to belong_to(:post) }
end

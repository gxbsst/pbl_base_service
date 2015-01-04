require 'rails_helper'

RSpec.describe Pbls::DiscussionMember, :type => :model do
  it { expect(described_class.new).to belong_to(:user) }
  it { expect(described_class.new).to belong_to(:discussion) }
end

require 'rails_helper'

RSpec.describe Groups::Post, :type => :model do
  it { expect(described_class.new).to belong_to(:user) }
  it { expect(described_class.new).to belong_to(:group) }
  it { expect(described_class.new).to validate_presence_of(:user_id) }
  it { expect(described_class.new).to validate_presence_of(:group_id) }
  it { expect(described_class.new).to validate_presence_of(:subject) }
  it { expect(described_class.new).to validate_presence_of(:body) }
end

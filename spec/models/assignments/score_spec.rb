require 'rails_helper'

RSpec.describe Assignments::Score, :type => :model do
  it { expect(described_class.new).to respond_to(:user_id)}
end

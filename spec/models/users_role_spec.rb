require 'rails_helper'

describe UsersRole do
  it { expect(described_class.new).to belong_to(:user)}
  it { expect(described_class.new).to belong_to(:role)}
end
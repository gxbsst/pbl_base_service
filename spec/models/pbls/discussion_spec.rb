require 'rails_helper'

describe Pbls::Discussion do
it { expect(described_class.new).to have_many(:discussion_members)}
it { expect(described_class.new).to have_many(:members) }
end
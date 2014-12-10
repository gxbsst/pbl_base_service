require 'rails_helper'

describe Pbls::StandardDecomposition do
  it { expect(described_class.new).to belong_to(:project) }
end
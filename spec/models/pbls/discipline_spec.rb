require 'rails_helper'

RSpec.describe Pbls::Discipline, :type => :model do
  it { expect(described_class.new).to validate_presence_of(:name) }

  let(:discipline) { described_class.new(name: 'java') }
  it { expect(discipline.name).to eq('java') }
end

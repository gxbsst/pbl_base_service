require 'rails_helper'

describe Curriculums::Phase do
  it { expect(described_class.new).to belong_to(:subject) }
  it { expect(described_class.new).to have_many(:curriculums) }
  it { expect(described_class.new).to validate_presence_of(:name) }
end
require 'rails_helper'

RSpec.describe Pbls::Knowledge, :type => :model do
  it { expect(described_class.new).to validate_presence_of(:description) }
  it { expect(described_class.new).to belong_to(:project) }

  let(:knowledge) { described_class.new(description: 'spring hibernate') }
  it { expect(knowledge.description).to eq('spring hibernate') }
end



# describe Pbls::Project do
#
#   it { expect(described_class.new).to_not validate_presence_of(:name) }
#   it { expect(described_class.new).to have_many(:standard_decompositions) }
#   it { expect(described_class.new).to belong_to(:user) }
#
#   let(:project) { described_class.new(name: 'name', driven_issue: 'driven_issue')}
#   it { expect(project).to be_valid }
#   it { expect(project.name).to eq('name') }
#   it { expect(project.driven_issue).to eq('driven_issue') }
# end
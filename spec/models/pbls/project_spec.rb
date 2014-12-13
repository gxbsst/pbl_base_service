require 'rails_helper'

describe Pbls::Project do

 it { expect(described_class.new).to_not validate_presence_of(:name) }
 it { expect(described_class.new).to have_many(:standard_decompositions) }
 it { expect(described_class.new).to belong_to(:user) }
 it { expect(described_class.new).to have_many(:rules) }

 it { expect(described_class.new).to respond_to(:rule_head) }
 it { expect(described_class.new).to respond_to(:rule_template) }

 let(:project) { described_class.new(name: 'name', driven_issue: 'driven_issue')}
 it { expect(project).to be_valid }
 it { expect(project.name).to eq('name') }
 it { expect(project.driven_issue).to eq('driven_issue') }
end
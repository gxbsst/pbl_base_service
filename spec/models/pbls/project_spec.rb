require 'rails_helper'

describe Pbls::Project do

 it { expect(described_class.new).to_not validate_presence_of(:name) }
 it { expect(described_class.new).to have_many(:standard_decompositions) }
 it { expect(described_class.new).to have_many(:techniques) }
 it { expect(described_class.new).to have_many(:standard_items) }
 it { expect(described_class.new).to belong_to(:user) }
 it { expect(described_class.new).to have_many(:rules) }

 it { expect(described_class.new).to respond_to(:rule_head) }
 it { expect(described_class.new).to respond_to(:rule_template) }

 let(:project) { described_class.new(name: 'name', driven_issue: 'driven_issue')}
 it { expect(project).to be_valid }
 it { expect(project.name).to eq('name') }
 it { expect(project.driven_issue).to eq('driven_issue') }

 it { expect(described_class.new).to respond_to(:tags) }

 it "create a project with tags" do
  project = Pbls::Project.create
  project.tag_list = 'a,b,c'
  project.save!
  project.reload
  expect(project.tags.collect(&:name)).to match_array(['a','b','c'])
 end

 describe 'with include Resourceable' do
   it { expect(described_class.new).to respond_to(:resources) }

  it 'create a resource' do
   p = described_class.new
   p.resources.build(name: 'name')
   p.save!

   expect(Resource.first.owner).to eq(p)
  end
 end

 describe "#limitation" do
  let(:project) { Pbls::Project.create(:limitation => "1")}
  it { expect(project.limitation).to eq(1)}
 end
end
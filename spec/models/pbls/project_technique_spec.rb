require 'rails_helper'

RSpec.describe Pbls::ProjectTechnique, :type => :model do
 it { expect(described_class.new).to respond_to(:technique_id)}
end

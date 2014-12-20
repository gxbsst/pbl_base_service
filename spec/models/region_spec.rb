require 'rails_helper'
require 'region'
RSpec.describe Region, :type => :model do
  describe '#self_and_ancestors' do
    let!(:country) {@country = Country.create!(:name => 'name') }
    let!(:province) { Province.create!(:name => 'name', parent_id: country.id) }
    let!(:city) {Country.create!(:name => 'name', parent_id: province.id) }

    it { expect(city.self_and_ancestors.collect{|i| i.id}).to match_array([country.id, province.id, city.id])}
  end

end

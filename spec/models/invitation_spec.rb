require 'rails_helper'

RSpec.describe Invitation, :type => :model do
  it{ expect(described_class.new).to validate_uniqueness_of(:code) }
  it{ expect(described_class.new).to validate_presence_of(:code) }
  describe '#code' do
    context 'with Student' do
      let!(:user) { create(:user, :email => 'gxbsst@gmail.com', :password => 'secret', type: 'Student')}

      it { expect(Invitation.count).to eq(1) }
    end

    context 'with Teacher' do
      let!(:user) { create(:user, :email => 'gxbsst@gmail.com', :password => 'secret', type: 'Teacher')}
      it { expect(Invitation.count).to eq(0) }
    end

    context 'with Parent' do
      let!(:user) { create(:user, :email => 'gxbsst@gmail.com', :password => 'secret', type: 'Parent')}
      it { expect(Invitation.count).to eq(0) }
    end

  end
end

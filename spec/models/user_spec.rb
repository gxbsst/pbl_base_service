require 'rails_helper'
describe User do
  describe '.new' do
    let(:user) { User.new }
    it { expect(user).to be_invalid }
  end

  it { expect(described_class.new).to respond_to(:avatar)}
  describe '.find_by_email' do
    let!(:user) { create(:user, :email => 'gxbsst@gmail.com', :password => 'secret')}

    it { expect(User.find_by_email('gxbsst@gmail.com').email).to eq('gxbsst@gmail.com')}
  end

   it { expect(described_class.new).to have_many(:friends) }
  it { expect(described_class.new).to validate_uniqueness_of(:username) }
end
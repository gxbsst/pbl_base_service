require 'rails_helper'
describe User do
  describe '.new' do
    let(:user) { User.new }
    it { expect(user).to be_invalid }
  end

  it { expect(described_class.new).to respond_to(:avatar)}
  it { expect(described_class.new).to respond_to(:realname)}
  it { expect(described_class.new).to respond_to(:nickname)}

  it { expect(described_class.new).to respond_to(:disciplines)}
  it { expect(described_class.new).to respond_to(:interests)}

  describe '.find_by_email' do
    let!(:user) { create(:user, :email => 'gxbsst@gmail.com', :password => 'secret')}

    it { expect(User.find_by_email('gxbsst@gmail.com').email).to eq('gxbsst@gmail.com')}
  end

  it { expect(described_class.new).to have_many(:friends) }
  it { expect(described_class.new).to validate_uniqueness_of(:username) }

  # describe '#invite_code' do
  #   context 'with Student' do
  #     let!(:user) { create(:user, :email => 'gxbsst@gmail.com', :password => 'secret', type: 'Student')}
  #
  #     it { expect(user.user_invite_code).to_not be_nil }
  #   end
  #
  #   context 'with Teacher' do
  #     let!(:user) { create(:user, :email => 'gxbsst@gmail.com', :password => 'secret', type: 'Teacher')}
  #
  #     it { expect(user.user_invite_code).to be_nil }
  #   end
  #
  #   context 'with Parent' do
  #     let!(:user) { create(:user, :email => 'gxbsst@gmail.com', :password => 'secret', type: 'Parent')}
  #
  #     it { expect(user.user_invite_code).to be_nil}
  #   end
  #
  # end
end
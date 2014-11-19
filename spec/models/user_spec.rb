describe User do
  describe '.new' do
    let(:user) { User.new }
    it { expect(user).to be_valid }
  end

  describe '.create' do
    let(:user) { User.create }
  end
end
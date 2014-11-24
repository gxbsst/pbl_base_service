describe User do
  describe '.new' do
    let(:user) { User.new }
    it { expect(user).to be_valid }
  end

  describe '.find_by_email' do
    let!(:user) { create(:user, :email => 'gxbsst@gmail.com', :password => 'secret')}

    it { expect(User.find_by_email('gxbsst@gmail.com').email).to eq('gxbsst@gmail.com')}
  end

  describe '.authenticate' do
    it "returns user only if username and password match" do
      user = create(:user, email: "gxbsst@gmail.com", password: "secret")
      expect(User.authenticate("gxbsst@gmail.com", "secret")).to eq(user)
      expect(User.authenticate("foobar2", "secret")).to be_nil
      expect(User.authenticate("foobar", "secret2")).to be_nil
    end
  end

  describe '#authenticate' do
    let!(:user) { create(:user, :email => 'gxbsst@gmail.com', :password => 'secret')}

    context 'be authenticated' do
      it { expect(User.first.authenticate('secret')).to eq(User.first)}
    end

    context 'be not authenticated' do
      it { expect(User.first.authenticate('error')).to be(false) }
    end
  end
end
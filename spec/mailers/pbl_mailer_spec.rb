require 'rails_helper'
describe PblMailer do
  include Rails.application.routes.url_helpers
  describe ".starting" do
    # let!(:course) { create :course, name: 'course name'}
    before(:all) do
      p = { from: 'gxbsst@gmail.com', to: 'gxbsst@gmail.com', subject: 'subject', body: 'body'}
      @email = PblMailer.run(p)
    end

    it { expect(@email).to deliver_to('gxbsst@gmail.com') }
    it { expect(@email).to deliver_from('gxbsst@gmail.com') }
    it { expect(@email).to have_subject("subject") }
    it { expect(@email).to have_body_text(/body/) }
  end
end
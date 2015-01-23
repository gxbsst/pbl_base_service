require 'rails_helper'

RSpec.describe V1::Feed::PostsController, :type => :request do

  describe 'GET #index' do
    let(:owner) { create :group }
    let(:sender) { create :user }

  end
end

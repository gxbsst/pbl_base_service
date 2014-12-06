require 'rails_helper'

describe V1::Skill::CategoriesController do

  describe 'GET #show' do
    let(:category) { create(:skill_category, name: 'name')}
    before(:each) do
      get :show, id: category, format: :json
    end

    it { expect(response).to render_template :show}
    it { expect(assigns(:category)).to eq(category)}
  end
end
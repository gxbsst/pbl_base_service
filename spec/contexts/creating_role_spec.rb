require 'rails_helper'

describe CreatingRole do
  let(:clazz) { described_class }
  let(:user) { create :user }
  let(:resource) { create :pbl_project }
  let(:listener) { double.as_null_object }

  context 'params[:role] is a Hash' do
    let(:params)  {
      {
          role: {
              name: 'teacher',
              resource_id: resource.id,
              resource_type: resource.class.name.demodulize,
              user_id: user.id
          }
      }
    }

    it 'create a role' do
      clazz.create(listener, params[:role])

      expect(Role.count).to be(1)
      expect(UsersRole.count).to be(1)
    end
  end

  context 'params[:role] is a Array' do
    let(:params)  {
      {
          role: [
              {
                  name: 'teacher',
                  resource_id: resource.id,
                  resource_type: resource.class.name.demodulize,
                  user_id: user.id
              },
              {
                  name: 'teacher',
                  resource_id: resource.id,
                  resource_type: resource.class.name.demodulize,
                  user_id: user.id
              }
          ]
      }
    }

    it 'create a role' do
      clazz.create(listener, params[:role])
      expect(Role.count).to be(2)
    end
  end

  context 'role item dose exist'
end
require 'rails_helper'

describe CreatingUsersRole do
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
      expect(listener).to receive(:create_on_success)
      clazz.create(listener, params[:role])
      expect(Role.count).to be(1)
      expect(UsersRole.count).to be(1)
    end
  end

  context 'params[:role] is a Array' do
    let(:resource_2) { create :pbl_project }
    let(:params)  {
      {
        role: [
                {
                  name: 'teacher',
                  resource_id: resource_2.id,
                  resource_type: resource_2.class.name.demodulize,
                  user_id: user.id
                },
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
      class_instance = clazz.create(listener, params[:role])
      expect(Role.count).to be(2)
      expect(UsersRole.count).to be(2)
    end
    context 'with errors' do
      it 'create roles ' do
        class_instance = clazz.create(listener, params[:role])
        expect(class_instance.errors.size).to eq(1)
      end
    end
  end

  context 'without user_id' do
    let(:params)  {
      {
        role: {
          name: 'teacher',
          resource_id: resource.id,
          resource_type: resource.class.name.demodulize
        }
      }
    }

    it { expect{ clazz.create(listener, params[:role])}.to raise_error(RuntimeError)}
  end

end
require 'rails_helper'

describe ValidatingPassword do
 let!(:user)  { create :user, email: 'g@gmail.com', password: 'secret' }
 let(:listener){ double.as_null_object }

 context 'success' do
  it  'validate password' do
   expect(listener).to receive(:validate_on_success).with(user)
   ValidatingPassword.validate(listener, 'g@gmail.com', 'secret')
  end
 end

 context 'error' do
  it  'validate password' do
   expect(listener).to receive(:validate_on_error).with('Not Found')
   ValidatingPassword.validate(listener, 'g@gmail.com', 'error')
  end
 end

end
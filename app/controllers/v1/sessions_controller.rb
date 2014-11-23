module V1
  class SessionsController < BaseController
    respond_to :json

    def create
      @user = User.authenticate(params[:email], params[:password])
      render 'v1/users/show'
    end
  end
end

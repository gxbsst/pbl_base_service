module V1
  class SessionsController < BaseController
    respond_to :json

    def create
      # @user = User.authenticate(params[:email], params[:password])
      ValidatingPassword.validate(self, params[:login], params[:password])
    end

    def validate_on_success(user)
      @user = user
      render 'v1/users/show'
    end

    def validate_on_error(errors)
      render json: { message: errors}, status: :not_found
    end
  end
end

module V1
  class SessionsController < BaseController
    respond_to :json

    def create
      # @user = User.authenticate(params[:email], params[:password])
      ValidatingPassword.validate(self, params[:login], params[:password])
    end

    def validate_on_success(user)
      @clazz_instance = user
      render 'v1/users/show', status: :ok
    end

    def validate_on_error(errors)
      render json: {error: errors}, status: :not_found
    end
  end
end

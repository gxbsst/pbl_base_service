module V1
  class UsersController < BaseController
    respond_to :json

    def index
      @users = User.all
    end

    def create
      user = User.create(user_params)
      render json: { id: user.id }, status: :created
    end

    def update
      set_user
      @user.update_attributes(user_params)
      render json: { id: @user.id }, status: :ok
    end

    def show
     set_user
    end

    def destroy
      set_user
      @user.delete

      render json: { id: @user.id }, status: :ok
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name)
    end

    def set_user
     @user ||= User.find(params[:id])
    end

  end
end

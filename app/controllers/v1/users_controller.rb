module V1
  class UsersController < BaseController
    respond_to :json

    def index
      @users = User.order(created_at: :desc)
      @users = @users.where(id: params[:id]) if params[:id].present?
      @users = @users.where('first_name like ?', params[:first_name]) if params[:first_name].present?
      @users = @users.where('last_name like ?', params[:last_name]) if params[:last_name].present?
      @users = @users.where(age: params[:age]) if params[:age].present?
      @users = @users.where(gender: params[:gender]) if params[:gender].present?
      @users
    end

    def create
      @user = User.create(user_params)
      # render json: { id: user.id }, status: :created
      render :show, status: :created
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
      params.require(:user).permit(:first_name, :last_name, :age, :gender, :email, :password)
    end

    def set_user
     @user ||= User.find(params[:id])
    end

  end
end

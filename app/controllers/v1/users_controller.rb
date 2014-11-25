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
      if @users.blank?
        head :not_found
      end
    end

    def create
      @user = User.new(user_params)
      if @user.save
        render :show, status: :created
      else
        render json: { error: @user.errors }, status: :unprocessable_entity
      end
    end

    def update
      set_user
      if @user.update_attributes(user_params)
        render json: { id: @user.id }, status: :ok
      else
        render json: {error: @user.errors }, status: :unprocessable_entity
      end
    end

    def show
      set_user
      if !@user
        render json: {}, status: :not_found
      end
    end

    def destroy
      set_user
      return head :not_found if !@user

      if @user.delete
        render json: { id: @user.id }, status: :ok
      else
        head :unauthorized
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :age, :gender, :email, :password)
    end

    def set_user

      if /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/.match(params[:id])
        @user ||= User.find(params[:id])
      else
        @user ||= User.where(["username=:id OR email=:id", {id: params[:id]}]).try(:first) rescue nil
      end

      puts @user.inspect
    end

  end
end

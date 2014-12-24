module V1
  class FollowsController < BaseController
    include Surrounded

    def create
      user = User.find(params[:follow][:user_id])
      follower = User.find(params[:follow][:follower_id])
      
      CreatingFollow.create(self, user, follower)
    end

    def destroy
     DestroyingFollow.destroy(self, params[:follow])
    end

    def on_create_success(follow)
      @clazz_instance = follow
      render :show, status: :created
    end

    def on_create_error(follow)
      render json: {error: follow.errors}, status: :unprocessable_entity
    end

    def on_destroy_success(follow)
      render json: {id: follow.id}, status: :ok
    end

    def on_destroy_error(errors)
      render json: {error: errors}, status: :unprocessable_entity
    end

    private
    def configures
      { have_parent_resource: false,
        clazz: Follow }
    end

    def set_clazz_instance
      @clazz_instance ||= configures[:clazz].find(params[:id]) rescue nil
    end

    def clazz_params
      params.fetch(:follow, {}).permit!
    end

  end
end
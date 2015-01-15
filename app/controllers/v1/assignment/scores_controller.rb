module V1
  class Assignment::ScoresController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections

      if params[:owner_id].present? && params[:owner_type].present?
        if params[:user_id].present?
          @collections = @collections.where(owner_id: params[:owner_id], owner_type: params[:owner_type], user_id: params[:user_id])
        else
          @collections = @collections.where(owner_id: params[:owner_id], owner_type: params[:owner_type])
        end
      end

      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    def create
      CreatingAssignmentsScore.create(self, params[:score])
    end

    def on_create_success
      render json: {}, status: :created
    end

    def on_create_error(errors)
      render json: {error: errors}, status: :unprocessable_entity
    end

    private
    def configures
      {
          have_parent_resource: false,
          clazz: Assignments::Score
      }
    end

    def clazz_params
      params.fetch(:score, {}).permit!
    end
  end
end

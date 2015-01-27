module V1
  class Assignment::ScoresController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections

      if params[:owner_type].present? || params[:owner_id].present? || params[:user_id].present? || params[:work_id].present?
        keys = %w(owner_type owner_id user_id work_id)
        query_hash = request.query_parameters.delete_if {|key, value| !keys.include?(key)}
        @collections = @collections.where(query_hash)
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

module V1
  class Assignment::WorksController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections

      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?

      if params[:task_type].present? && params[:task_id].present?
       @collections = @collections.where(task_id: params[:task_id], task_type: params[:task_type])
      end

      if params[:task_types].present? && params[:task_ids].present?
        @collections = @collections.where(task_id: params[:task_id], task_type: params[:task_type])
      end

      @collections = @collections.page(page).per(@limit) if @collections
    end

    def create
      CreatingAssignmentsWork.create(self, params[:work])
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
          clazz: Assignments::Work
      }
    end

    def clazz_params
      params.fetch(:work, {}).permit!
    end

  end
end
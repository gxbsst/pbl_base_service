module V1
  class Assignment::ScoresController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections

      if params[:work_id].present?
        @collections = @collections.where(work_id: params[:work_id])
      end

      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
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

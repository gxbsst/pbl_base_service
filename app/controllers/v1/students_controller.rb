module V1
  class StudentsController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      top_collections

      if params[:clazz_id].present?
        @collections = @collections.where(clazz_id: params[:clazz_id])
      end

      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    private

    def configures
      {
          have_parent_resource: false,
          clazz: Student
      }
    end

    def set_clazz_instance
      @clazz_instance ||= configures[:clazz].includes(:user).find(params[:id]) rescue nil
    end

    def clazz_params
      params.fetch(:student, {}).permit!
    end

  end
end

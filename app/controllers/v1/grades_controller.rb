module V1
  class GradesController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      top_collections

      if params[:school_id].present?
        @collections = @collections.where(school_id: params[:school_id])
      end

      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    private

    def configures
      {
          have_parent_resource: false,
          clazz: Grade
      }
    end

    def set_clazz_instance
      @clazz_instance ||= configures[:clazz].find(params[:id]) rescue nil
    end

    def clazz_params
      params.fetch(:grade, {}).permit!
    end

  end
end

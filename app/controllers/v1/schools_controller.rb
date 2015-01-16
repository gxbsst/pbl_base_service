module V1
  class SchoolsController < BaseController
    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      top_collections

      if params[:region_id].present?
        @collections = @collections.where(region_id: params[:region_id])
      end

      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    private

    def configures
      {
          have_parent_resource: false,
          clazz: School
      }
    end

    def set_clazz_instance
      @clazz_instance ||= configures[:clazz].find(params[:id]) rescue nil
    end

    def clazz_params
      params.fetch(:schools, {}).permit!
    end
  end
end

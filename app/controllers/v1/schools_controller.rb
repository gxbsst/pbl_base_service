module V1
  class SchoolsController < BaseController
    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      top_collections

      if params[:region_id].present? || params[:country_id].present? || params[:province_id].present? || params[:district_id].present?
        # keys = %w(region_id country_id province_id district_id)
        # query_hash  = request.query_parameters.delete_if{|key, value| !keys.include?(key) }
        @collections = @collections.where(["region_id = :id OR country_id = :id OR province_id = :id OR district_id = :id", {id: params[:region_id]}])
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

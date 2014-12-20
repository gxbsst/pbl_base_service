module V1
  class RegionsController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections
      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.find(params[:parent_id]).children if params[:parent_id].present?
      @collections = @collections.where(type: params[:type].classify) if params[:type].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    private

    def configures
      { have_parent_resource: false,
        clazz: Region,
        clazz_resource_name: 'children' }
    end

    def set_clazz_instance
      parse_includes
      @clazz_instance ||= configures[:clazz].find(params[:id]) rescue nil
    end

    def clazz_params
      params.fetch(:region, {}).permit!
    end

    def parse_includes
      include = params[:include] rescue nil
      if include
        @include = include.split(',')
        @include_parents = include.include? 'parents'
        @include_children = include.include? 'children'
      end
    end

  end
end

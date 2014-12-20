module V1
  class Pbl::ProductsController < BaseController
    def index
      parse_includes
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections
      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    private

    def configures
      {
        have_parent_resource: true,
        parent_resource_clazz: Pbls::Project,
        clazz: Pbls::Product,
        clazz_resource_name: 'products'
      }
    end

    def clazz_params
      params.fetch(:product, {}).permit!
    end

    def parent_resource_id
      params[:project_id] || params[:product][:project_id]
    rescue
      nil
    end

    def set_clazz_instance
      parse_includes
      @clazz_instance ||= configures[:clazz].includes(@include).find(params[:id]) rescue nil
    end

    def parse_includes
      include = params[:include] rescue nil
      if include
        @include = include.split(',')
        @include_product_form = include.include? 'product_form'
        @include_resources = include.include? 'resources'
      end
    end
  end
end
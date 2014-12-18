module V1
  class ResourcesController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      @collections = Resource.order(created_at: :desc)
      @collections = @collections.where(["owner_id = ? AND owner_type = ?", params[:owner_id], params[:owner_type]]) if params[:owner_type] && params[:owner_id]
      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit)
    end

    private

    def configures
      {
        have_parent_resource: true,
        clazz: Resource,
        clazz_resource_name: 'resources'
      }
    end

    def clazz_params
      params.fetch(:resource, {}).permit!
    end

    def parent_resource_id
      params[:owner_id] || params[:resource][:owner_id]
    rescue
      nil
    end

    def set_parent_resource_instance
      params[:owner_type].constantize.find(check_parent_resource_id) rescue nil
    end
  end
end
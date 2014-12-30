module V1
  class NotificationsController <  BaseController
    def index
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
        have_parent_resource: false,
        clazz: Notification
      }
    end

    def clazz_params
      params.fetch(:notification, {}).permit!
    end
  end
end

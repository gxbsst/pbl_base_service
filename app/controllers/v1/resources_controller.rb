module V1
  class ResourcesController < BaseController


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
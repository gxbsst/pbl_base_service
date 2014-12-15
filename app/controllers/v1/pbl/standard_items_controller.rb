module V1
  class Pbl::StandardItemsController < BaseController

    private

    def configures
      {
        have_parent_resource: true,
        parent_resource_clazz: Pbls::Project,
        clazz: Pbls::StandardItem,
        clazz_resource_name: 'standard_items'
      }
    end

    def clazz_params
      params.fetch(:standard_item, {}).permit!
    end

    def parent_resource_id
      params[:project_id] || params[:standard_item][:project_id]
    rescue
      nil
    end
  end
end
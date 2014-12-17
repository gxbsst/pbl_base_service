module V1
  class Curriculum::StandardItemsController <  BaseController

    private

    def configures
      {
        have_parent_resource: true,
        parent_resource_clazz: Curriculums::Standard,
        clazz: Curriculums::StandardItem,
        clazz_resource_name: 'items'
      }
    end

    def clazz_params
      params.fetch(:standard_item, {}).permit!
    end

    def parent_resource_id
      params[:standard_id] || params[:standard_item][:standard_id]
    rescue
      nil
    end
  end
end
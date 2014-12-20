module V1
  class Curriculum::StandardsController <  BaseController

    private

    def configures
      {
        have_parent_resource: true,
        parent_resource_clazz: Curriculums::Phase,
        clazz: Curriculums::Standard,
        clazz_resource_name: 'standards'
      }
    end

    def clazz_params
      params.fetch(:standard, {}).permit!
    end

    def parent_resource_id
      params[:phase_id] || params[:standard][:phase_id]
    rescue
      nil
    end
  end
end
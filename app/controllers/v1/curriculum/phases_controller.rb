module V1
  class Curriculum::PhasesController <  BaseController
    private

    def configures
      {
        have_parent_resource: true,
        parent_resource_clazz: Curriculums::Subject,
        clazz: Curriculums::Phase,
        clazz_resource_name: 'phases'
      }
    end

    def clazz_params
      params.fetch(:phase, {}).permit!
    end

    def parent_resource_id
      params[:subject_id] || params[:phase][:subject_id]
    rescue
      nil
    end
  end
end
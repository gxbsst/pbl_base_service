module V1
  class Curriculum::SubjectsController < BaseController

    private

    def configures
      {
        have_parent_resource: false,
        clazz: Curriculums::Subject
      }
    end

    def clazz_params
      params.fetch(:subject, {}).permit!
    end

  end
end
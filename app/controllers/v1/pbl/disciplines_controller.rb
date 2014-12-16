module V1
  class Pbl::DisciplinesController < BaseController

    private

    def configures
      {
          have_parent_resource: false,
          clazz: Pbls::Discipline,
          clazz_resource_name: 'disciplines'
      }
    end

    def clazz_params
      params.fetch(:discipline, {}).permit!
    end

  end
end
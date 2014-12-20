module V1
  class Skill::CategoriesController < BaseController

    private

    def configures
      {
        have_parent_resource: false,
        clazz: Skills::Category
      }
    end

    def clazz_params
      params.fetch(:category, {}).permit!
    end

  end
end
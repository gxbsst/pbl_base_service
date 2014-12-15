module V1
  class Skill::TechniquesController < BaseController
    private

    def configures
      {
        have_parent_resource: true,
        parent_resource_clazz: Skills::SubCategory ,
        clazz: Skills::Technique,
        clazz_resource_name: 'techniques'
      }
    end

    def clazz_params
      params.fetch(:technique, {}).permit!
    end

    def parent_resource_id
      params[:sub_category_id] || params[:technique][:sub_category_id]
    rescue
      nil
    end
  end
end
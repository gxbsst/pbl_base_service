module V1
  class Skill::SubCategoriesController <  BaseController

    private

    def configures
      {
        have_parent_resource: true,
        parent_resource_clazz: Skills::Category ,
        clazz: Skills::SubCategory,
        clazz_resource_name: 'sub_categories'
      }
    end

    def clazz_params
      params.fetch(:sub_category, {}).permit!
    end

    def parent_resource_id
      params[:category_id] || params[:technique][:sub_category_id]
    rescue
      nil
    end
  end
end
module V1
 class Skill::CategoriesController <  BaseController
  def show
   set_category
   render json: {}, status: :not_found unless @category
  end

  private
  def set_category
   include = params[:include] rescue nil
   @category ||= Skills::Category.includes(include).find(params[:id]) rescue nil
  end
 end
end
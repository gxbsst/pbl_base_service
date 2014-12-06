module V1
 class Skill::CategoriesController <  BaseController
  def show
   set_category
   render json: {}, status: :not_found unless @category
  end

  def create
   set_skill
   @category = @skill.categories.build(category_params)

   if @category.save
    render :show, status: :created
   else
    render json: { error: @category.errors }, status: :unprocessable_entity
   end
  end

  def update
   set_category

   if @category.update_attributes(category_params)
    render json: { id: @category.id }, status: :ok
   else
    render json: {error: @category.errors}, status: :unprocessable_entity
   end
  end

  def destroy
   set_category
   return head :not_found unless @category

   if @category.delete
    render json: { id: @category.id }, status: :ok
   else
    head :unauthorized
   end
  end

  private

  def set_category
   include = params[:include] rescue nil
   @category ||= Skills::Category.includes(include).find(params[:id]) rescue nil
  end

  def set_skill
   skill_id = params[:skill_id] || params[:category][:skill_id] rescue nil
   fail 'No Skill Id' if !skill_id

   @skill ||= ::Skill.find(skill_id) rescue nil
  end

  def category_params
   params.require(:category).permit(:name, :skill_id)
  end
 end
end
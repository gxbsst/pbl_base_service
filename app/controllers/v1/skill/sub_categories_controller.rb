module V1
 class Skill::SubCategoriesController <  BaseController
  def show
   set_sub_category
   render json: {}, status: :not_found unless @sub_category
  end

  def create
   set_category
   @sub_category = @sub_category.sub_categories.build(category_params)

   if @sub_category.save
    render :show, status: :created
   else
    render json: { error: @sub_category.errors }, status: :unprocessable_entity
   end
  end

  def update
   set_sub_category

   if @sub_category.update_attributes(category_params)
    render json: { id: @sub_category.id }, status: :ok
   else
    render json: {error: @sub_category.errors}, status: :unprocessable_entity
   end
  end

  def destroy
   set_sub_category
   return head :not_found unless @sub_category

   if @sub_category.delete
    render json: { id: @sub_category.id }, status: :ok
   else
    head :unauthorized
   end
  end

  private

  def set_sub_category
   include = params[:include] rescue nil
   @sub_category ||= Skills::SubCategory.includes(include).find(params[:id]) rescue nil
  end

  def set_category
   category_id = params[:category_id] || params[:sub_category][:category_id] rescue nil
   fail 'No category Id' unless category_id

   @sub_category ||= Skills::Category.find(category_id) rescue nil
  end

  def category_params
   params.require(:sub_category).permit(:name, :category_id)
  end
 end
end
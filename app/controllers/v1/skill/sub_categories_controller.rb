module V1
 class Skill::SubCategoriesController <  BaseController

  def index
   page = params[:page] || 1
   @limit = params[:limit] || 10

   @sub_categories = Skills::SubCategory.order(created_at: :desc)
   @sub_categories = @sub_categories.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
   @sub_categories = @sub_categories.where(category_id: params[:category_id]) if params[:category_id].present?
   @sub_categories = @sub_categories.page(page).per(@limit)

   if @sub_categories.blank?
    head :not_found
   end
  end

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
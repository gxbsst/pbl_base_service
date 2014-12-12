module V1
  class Skill::CategoriesController < BaseController
    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      @categories = Skills::Category.order(created_at: :desc)
      @categories = @categories.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @categories = @categories.page(page).per(@limit)
    end

    def show
      set_category
      if !@category
        render json: {}, status: :not_found
      end
    end

    def create
      @category = Skills::Category.new(category_params)

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
      return head :not_found if !@category

      if @category.destroy
        render json: { id: @category.id }, status: :ok
      else
        head :unauthorized
      end
    end

    private

    def category_params
      params.require(:category).permit!
    end

    def set_category
      include = params[:include] rescue nil
      @category ||= Skills::Category.includes(include).find(params[:id]) rescue nil
    end

  end
end
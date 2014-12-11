module V1
  class Pbl::ProductsController < BaseController

    def index
      set_project
      page = params[:page] || 1
      limit = params[:limit] || 10

      @products = @project.products.order(created_at: :desc)
      @products = @products.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @products = @products.page(page).per(limit)
    end

    def show
      set_product

      if !@product
        render json: {}, status: :not_found
      end
    end

    def create
      check_project_id
      @product = Pbls::Product.new(product_params)

      if @product.save
        render :show, status: :created
      else
        render json: { error: @product.errors }, status: :unprocessable_entity
      end
    end

    def update
      set_product

      if @product.update_attributes(product_params)
        render :show, status: :ok
      else
        render json: {error: @product.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      set_product
      return head :not_found if !@product

      if @product.destroy
        render json: { id: @product.id }, status: :ok
      else
        head :unauthorized
      end
    end

    private

    def product_params
      params.fetch(:product, {}).permit!
    end

    def set_product
      include = params[:include] rescue nil
      @product ||= Pbls::Product.includes(include).find(params[:id]) rescue nil
    end

    def set_project
      @project ||= Pbls::Project.find(check_project_id) rescue nil
    end

    def check_project_id
      project_id = params[:project_id] || params[:product][:project_id] rescue nil
      fail 'No Project Id' unless project_id
      project_id
    end
  end
end
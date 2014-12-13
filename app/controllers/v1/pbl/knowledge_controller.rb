module V1
  class Pbl::KnowledgesController < BaseController

    # def index
    #   set_project
    #   # page = params[:page] || 1
    #   # @limit = params[:limit] || 10
    #
    #   @products = @project.products.order(created_at: :desc)
    #   # @products = @products.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
    #   # @products = @products.page(page).per(@limit)
    # end
    #
    # def show
    #   set_product
    #
    #   if !@product
    #     render json: {}, status: :not_found
    #   end
    # end

    def create
      check_project_id
      @knowledge = Pbls::Knowledge.new(product_params)

      if @knowledge.save
        render :show, status: :created
      else
        render json: { error: @knowledge.errors }, status: :unprocessable_entity
      end
  end

    # def update
    #   set_product
    #
    #   if @product.update_attributes(product_params)
    #     render :show, status: :ok
    #   else
    #     render json: {error: @product.errors}, status: :unprocessable_entity
    #   end
    # end
    #
    # def destroy
    #   set_product
    #   return head :not_found if !@product
    #
    #   if @product.destroy
    #     render json: { id: @product.id }, status: :ok
    #   else
    #     head :unauthorized
    #   end
    # end

    private

    def knowledge_params
      params.fetch(:knowledge, {}).permit!
    end

    def set_knowledge
      include = params[:include] rescue nil
      @knowledge ||= Pbls::Knowledge.ilncudes(include).find(params[:id]) rescue nil
    end

    def set_project
      @project ||= Pbls::Project.find(check_project_id) rescue nil
    end

    def check_project_id
      project_id = params[:project_id] || params[:knowledge][:project_id] rescue nil
      fail 'No Project Id' unless project_id
      project_id
    end
  end
end
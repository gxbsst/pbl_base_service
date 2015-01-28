module V1
  class Todo::TodosController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections

      if params[:user_id].present? || params[:repeat_by].present? || params[:state].present?
        keys = %w(user_id repeat_by state)
        query_hash = request.query_parameters.delete_if {|key, value| !keys.include?(key)}
        @collections = @collections.where(query_hash)
      end

      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    def create
      check_parent_resource_id if configures[:have_parent_resource]

      @clazz_instance = configures[:clazz].new(clazz_params)

      if @clazz_instance.save
        render :show, status: :created
      else
        render json: { error: @clazz_instance.errors }, status: :unprocessable_entity
      end
    end

    private

    def top_collections
      @collections = configures[:clazz].order(created_at: :desc)
    end

    def configures
      {
          have_parent_resource: false,
          clazz: Todos::Todo
      }
    end

    def set_clazz_instance
      @clazz_instance ||= configures[:clazz].find(params[:id]) rescue nil
    end

    def clazz_params
      params.fetch(:todo, {}).permit!
    end
  end
end

module V1
  class Todo::TodoItemsController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections

      if params[:user_id].present?
        keys = %w(user_id)
        query_hash = request.query_parameters.delete_if {|key, value| !keys.include?(key)}
        @collections = @collections.where(query_hash)
      end

      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    private

    def top_collections
      @collections = configures[:clazz].includes(:todo).order(created_at: :desc)
    end

    def configures
      {
          have_parent_resource: false,
          clazz: Todos::TodoItem
      }
    end

    def set_clazz_instance
      @clazz_instance ||= configures[:clazz].includes(:todo).find(params[:id]) rescue nil
    end

    def clazz_params
      params.fetch(:todo_item, {}).permit!
    end
  end
end

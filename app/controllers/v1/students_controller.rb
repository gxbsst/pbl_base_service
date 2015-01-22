module V1
  class StudentsController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      top_collections

      if params[:clazz_id].present? || params[:user_id].present?
        keys = %w(clazz_id user_id)
        query_hash = request.query_parameters.delete_if {|key, value| !keys.include?(key)}
        @collections = @collections.where(query_hash)
      end

      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    private

    def configures
      {
          have_parent_resource: false,
          clazz: Student
      }
    end

    def set_clazz_instance
      @clazz_instance ||= configures[:clazz].includes(:user).find(params[:id]) rescue nil
    end

    def clazz_params
      params.fetch(:student, {}).permit!
    end

  end
end

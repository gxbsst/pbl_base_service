module V1
  class ClazzsController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      top_collections

      if params[:grade_id].present?
        @collections = @collections.where(grade_id: params[:grade_id])
      end

      if params[:school_id].present?
        @collections = @collections.where(school_id: params[:school_id])
      end

      if params[:name].present?
        @collections = @collections.where(["name LIKE ?", "%#{params[:name]}%"])
      end

      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    private

    def top_collections
      @collections = configures[:clazz].includes(students: [:user]).order(created_at: :desc)
    end

    def configures
      {
          have_parent_resource: false,
          clazz: Clazz
      }
    end

    def set_clazz_instance
      @clazz_instance ||= configures[:clazz].includes(students: [:user]).find(params[:id]) rescue nil
    end

    def clazz_params
      params.fetch(:clazz, {}).permit!
    end

  end
end

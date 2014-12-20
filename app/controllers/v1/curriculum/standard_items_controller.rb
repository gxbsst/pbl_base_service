module V1
  class Curriculum::StandardItemsController <  BaseController

    def index
      parse_includes
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections

      if params[:ids].present?
        if params[:include] == 'parents'
          @collections = @collections.includes(@include).where(id: params[:ids].gsub(/\s+/, "").split(','))
        else
          @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(','))
        end
      end
      @collections = @collections.page(page).per(@limit) if @collections
    end

    private

    def configures
      {
        have_parent_resource: true,
        parent_resource_clazz: Curriculums::Standard,
        clazz: Curriculums::StandardItem,
        clazz_resource_name: 'items'
      }
    end

    def clazz_params
      params.fetch(:standard_item, {}).permit!
    end

    def parent_resource_id
      params[:standard_id] || params[:standard_item][:standard_id]
    rescue
      nil
    end

    def set_clazz_instance
      parse_includes
      @clazz_instance ||= configures[:clazz].includes(@include).find(params[:id]) rescue nil
    end

    def parse_includes
      include = params[:include] rescue nil
      if include
        @include =  [standard: [phase:[:subject]]]
        @include_parents = include.include? 'parents'
      end
    end
  end
end
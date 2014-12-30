module V1
  class Group::PostsController < BaseController
    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections

      if params[:user_id].present?
        @collections = @collections.where(user_id: params[:user_id])
      end

      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    private

    def configures
      {
          have_parent_resource: true,
          parent_resource_clazz: Groups::Group,
          clazz: Groups::Post,
          clazz_resource_name: 'posts'
      }
    end

    def clazz_params
      params.fetch(:post, {}).permit!
    end

    def parent_resource_id
      params[:group_id] || params[:post][:group_id]
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
        @include = include.split(',')
        @include_replies = include.include? 'replies'
      end
    end
  end
end

module V1
  class Group::GroupsController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections

      if params[:owner_type].present? || params[:owner_id].present?
        keys = %w(owner_type owner_id)
        query_hash = request.query_parameters.delete_if {|key, value| !keys.include?(key)}
        @collections = @collections.where(query_hash)
      end

      if params[:owner_ids].present?
        owner_ids = params[:owner_ids].split(',')
        @collections = @collections.where(owner_id: owner_ids)
      end

      if params[:name].present?
        @collections = @collections.where(["name LIKE ?", "%#{params[:name]}%"])
      end

      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    # == examples
    # {
    #  group: {user_id: user_id, name: 'group_name', description: 'description'}
    # }
    def create
      CreatingGroup.create(self,params[:group])
    end

    def on_create_success(group)
      @clazz_instance = group
      render :show, status: :created
    end

    def on_create_error(group)
      render json: {error: group.errors}, status: :unprocessable_entity
    end

    private

    def configures
      {
        have_parent_resource: false,
        clazz: Groups::Group
      }
    end

    def set_clazz_instance
      parse_includes
      @clazz_instance ||= configures[:clazz].includes(@include).find(params[:id]) rescue nil
    end

    def clazz_params
      params.fetch(:group, {}).permit!
    end

    def parse_includes
      include = params[:include] rescue nil
      if include
        @include = include.split(',')
        @include_member_ships = include.include? 'member_ships'
      end
    end

  end
end
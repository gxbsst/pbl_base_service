# encoding: utf-8
module V1
  class Group::MemberShipsController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections

      if params[:user_id].present?
        @collections = @collections.includes(:group).where(user_id: params[:user_id])
      end
      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    # = join a group
    # == examples
    # === @params
    # POST /groups/member_ships
    # {
    #  member_ship: {user_id: user_id, group_id: 'group_id', role: ['creator']}
    # }
    def create
      CreatingMemberShip.create(self, params[:member_ship])
    end

    # = leave a group
    # == examples
    # === @params
    # DELETE /groups/member_ships/:id
    def destroy
      DestroyingMemberShip.destroy(self, params[:id])
    end

    def on_create_success(member_ship)
      @clazz_instance = member_ship
      render :show, status: :created
    end

    def on_create_error(member_ship)
      render json: {error: member_ship.errors}, status: :unprocessable_entity
    end

    def on_destroy_success(member_ship)
      render json: {id: member_ship.id}, status: :ok
    end

    def on_destroy_error(errors)
      render json: {error: errors}, status: :unprocessable_entity
    end

    private

    def configures
      {
        have_parent_resource: true,
        parent_resource_clazz: Groups::Group,
        clazz: Groups::MemberShip,
        clazz_resource_name: 'member_ships'
      }
    end

    def clazz_params
      params.fetch(:member_ship, {}).permit!
    end

    def parent_resource_id
      params[:group_id] || params[:member_ship][:group_id]
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
      end
    end

    def top_collections
      if configures[:have_parent_resource] && parent_resource_id.present?
        set_parent_resource_instance
        unless @parent_resource_instance
          return render json: {data: [], meta: {}}
        end
        @collections = @parent_resource_instance.send(:"#{configures[:clazz_resource_name]}").order(created_at: :desc)
      else
        @collections = configures[:clazz].order(created_at: :desc)
      end
    end
  end
end

module V1
  class Group::GroupsController < BaseController

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
        have_parent_resource: true,
        parent_resource_clazz: User,
        clazz: Groups::Group,
        clazz_resource_name: 'group'
      }
    end

    def parent_resource_id
      params[:user_id] || params[:group][:user_id]
    rescue
      nil
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
        @include_members = include.include? 'members'
      end
    end

  end
end
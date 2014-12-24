module V1
  class Group::MembersController < BaseController

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
      params.fetch(:member, {}).permit!
    end

    def parent_resource_id
      params[:group_id] || params[:member][:group_id]
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
        # TODO
        @include = include.split(',')
      end
    end
  end
end

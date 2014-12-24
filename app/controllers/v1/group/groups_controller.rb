module V1
  class Group::GroupsController < BaseController

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
      @clazz_instance ||= configures[:clazz].find(params[:id]) rescue nil
    end

    def clazz_params
      params.fetch(:group, {}).permit!
    end

  end
end
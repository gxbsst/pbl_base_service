module V1
  class UsersController < BaseController
    respond_to :json

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]

      top_collections
      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.where('first_name like ?', params[:first_name]) if params[:first_name].present?
      @collections = @collections.where('last_name like ?', params[:last_name]) if params[:last_name].present?
      @collections = @collections.where(age: params[:age]) if params[:age].present?
      @collections = @collections.where(gender: params[:gender]) if params[:gender].present?
      @collections = @collections.page(page).per(@limit)
    end

    private

    def configures
      {
        have_parent_resource: false,
        clazz: User,
      }
    end

    def clazz_params
      params.fetch(:user, {}).permit!
    end

    def set_clazz_instance
      parse_includes
      @clazz_instance ||= configures[:clazz].includes(@include).find_by_login(params[:id]) rescue nil
    end

    def parse_includes
      include = params[:include] rescue nil
      if include
        @include = include.split(',')
        @include_friends = include.include? 'friends'
        @include_school = include.include? 'school'
      end
    end

  end
end

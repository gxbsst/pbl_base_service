module V1
  class UsersController < BaseController
    respond_to :json

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]

      top_collections
      query

      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit)
    end

    private

    def configures
      {
        have_parent_resource: false,
        clazz: User,
        query: ['username']
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

    def query
      if params[:username].present?
        @collections = @collections.where(["username LIKE ?", "%#{params[:username]}%"])
      else
        keys = configures[:query]
        query_hash = request.query_parameters.delete_if {|key, value| !keys.include?(key)}
        @collections = @collections.where(query_hash) if query_hash.present?
      end
    end

  end
end

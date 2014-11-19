module V1
  class UsersController < BaseController
    respond_to :json

    def index
      @users = User.all
    end

  end
end

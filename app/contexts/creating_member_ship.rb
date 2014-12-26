class CreatingMemberShip

  def self.create(listener, params, options = {})
    fail 'miss user_id or group_id' if params[:user_id].blank? || params[:group_id].blank?
    new(listener, params, options).create
  end

  attr_reader :listener, :user, :group

  def initialize(listener, params, options = {})
    @listener = listener
    @user = User.find(params[:user_id]).extend(UserHelper)
    @group = Groups::Group.find(params[:group_id]).extend(GroupRole)
    @options = options
  end

  def create
    user.join(group) do |member_ship|

      if member_ship.valid?
        group.increase_member_count

        listener.on_create_success(member_ship)
      else
        listener.on_create_error(member_ship)
      end
    end
  end

  module UserHelper
    def join(group)
     yield Groups::MemberShip.create(user_id: self.id, group_id: group.id)
    end
  end

  module GroupRole
    def increase_member_count
      self.increment!(:members_count, 1)
    end
  end

end
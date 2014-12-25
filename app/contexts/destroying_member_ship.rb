class DestroyingMemberShip
  def self.destroy(listener, params)
    new(listener, params).destroy
  end

  attr_reader :user, :group, :listener

  def initialize(listener, params)
    @listener = listener
    @user = User.find(params[:user_id]).extend(UserRole)
    @group = Groups::Group.find(params[:group_id]).extend(GroupRole)
  end

  def destroy
    user.leave(group) do |success, member_ship|
      if success
        group.decrease_member_count
        listener.on_destroy_success(member_ship)
      else
        listener.on_destroy_error("the member_ship does not exist")
      end
    end
  end

  module UserRole
    def leave(group)
      member_ship = Groups::MemberShip.find_by(user_id: self.id, group_id: group.id)
      yield(member_ship.try(:destroy), member_ship)
      self
    end
  end

  module GroupRole
    def decrease_member_count
      self.decrement!(:members_count, 1)
    end
  end
end
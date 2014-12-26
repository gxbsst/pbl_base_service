class DestroyingMemberShip
  def self.destroy(listener, id, options = {})
    new(listener, id, options).destroy
  end

  attr_reader :user, :group, :listener, :member_ship

  def initialize(listener, id, options = {})
    @listener = listener
    @member_ship = Groups::MemberShip.find(id) rescue nil
  end

  def destroy
    if member_ship
      @user = member_ship.member
      @group = member_ship.group.extend(GroupRole)

      if member_ship.destroy
        @group.decrease_member_count
      end

      listener.on_destroy_success(member_ship)
    else
      listener.on_destroy_error("the member_ship does not exist")
    end
  end

  module GroupRole
    def decrease_member_count
      self.decrement!(:members_count, 1)
    end
  end
end
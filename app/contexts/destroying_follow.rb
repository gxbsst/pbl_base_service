class DestroyingFollow
  def self.destroy(listener, params, options = {})
    new(listener, params, options).destroy
  end

  attr_reader :user, :follower, :listener, :follow, :options

  def initialize(listener, id, options = {})
    @listener = listener
    @follow = Follow.find(id) rescue nil
    @options = options
  end

  def destroy
    if follow

      @user = follow.user.extend(UserRole)
      @follower = follow.follower.extend(FollowerRole)

      if follow.destroy && follower.be_friend_with?(@user)

        follower.remove_friend(@user)
        @user.remove_friend(@follower)
      end
      listener.on_destroy_success(follow)
    else
      listener.on_destroy_error('the follow does not exist')
    end
  end

  module UserRole
    def remove_friend(follower)
      FriendShip.find_by(user_id: self.id, friend_id: follower.id).destroy
    end
  end

  module FollowerRole
    def be_friend_with?(user)
      FriendShip.find_by(user_id: user.id, friend_id: self.id)
    end

    def remove_friend(user)
      FriendShip.find_by(user_id: self.id, friend_id: user.id).destroy
    end
  end
end
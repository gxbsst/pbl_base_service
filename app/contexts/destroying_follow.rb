class DestroyingFollow
  def self.destroy(listener, params)
    new(listener, params).destroy
  end

  attr_reader :user, :follower, :listener

  def initialize(listener, params)
    @listener = listener
    @user = ::User.find(params[:user_id]).extend(UserRole)
    @follower = ::User.find(params[:follower_id]).extend(FollowerRole)
  end

  def destroy
    follower.unfollow(user) do |success, follow|
      if success
        if follower.be_friend_with?(user)
          follower.remove_friend(user)
          user.remove_friend(follower)
        end

        listener.on_destroy_success(follow)
      else
        listener.on_destroy_error("the follow does not exist")
      end
    end
  end


  module UserRole
    def remove_friend(follower)
      FriendShip.find_by(user_id: self.id, friend_id: follower.id).try(:destroy)
    end
  end

  module FollowerRole
    def unfollow(user)
      follow = Follow.find_by(user_id: user.id, follower_id: self.id)
      yield(follow.try(:destroy), follow)
      self
    end

    def be_friend_with?(user)
      FriendShip.find_by(user_id: user.id, friend_id: self.id)
    end

    def remove_friend(user)
      FriendShip.find_by(user_id: self.id, friend_id: user.id).try(:destroy)
    end
  end
end
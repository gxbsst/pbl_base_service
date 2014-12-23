class CreatingFollow
  extend Surrounded::Context

  def self.create(listener, user, follower)
    new(listener, user, follower).create
  end

  initialize :listener, :user, :follower

  def create
    follower.follow(user)
  end

  trigger :create

  role :follower do
    def follow(user)
      follow = Follow.new(user_id: user.id, follower_id: self.id)
      if follow.save
        user.followed? self do |f|
          user.create_friend(self) if f.present?
        end
        listener.on_create_success(follow)
      else
        listener.on_create_error(follow)
      end
    end
  end

  role :user do
    def followed?(follower)
      yield Follow.where(user_id: follower.id, follower_id: self.id).try(:first)
    end

    def create_friend(follower)
      FriendShip.create(user_id: self.id, friend_id: follower.id)
      FriendShip.create(user_id: follower.id, friend_id: user.id)
    end
  end
end
class CreatingFriendShip

  def self.create(listener, params, options = {})
    fail 'miss user_id or friend_id' if params[:user_id].blank? || params[:friend_id].blank?
    new(listener, params, options).create
  end

  attr_reader :listener, :user, :friend, :options, :params

  def initialize(listener, params, options = {})
    @listener = listener
    @user = User.find(params[:user_id]).extend(UserRole)
    @friend = User.find(params[:friend_id]).extend(FriendRole)
    @options = options
    @params = params
  end

  def create
    friend_ship = FriendShip.create(user_id: user.id, friend_id: friend.id, relation: params[:relation])
    if friend_ship.valid?
      clone_ship(friend_ship)
      user.follow(friend)
      friend.follow(user)
      user.increment_friends_count
      friend.increment_friends_count

      listener.on_create_success(friend_ship)
    else
      listener.on_create_error(friend_ship)
    end
  end

  def clone_ship(friend_ship)
    FriendShip.create(user_id: friend_ship.friend_id,
                      friend_id: friend_ship.user_id,
                      relation: friend_ship.relation)
  end

  module UserRole
    def follow(friend)
      follow = Follow.new(user_id: friend.id, follower_id: self.id)

      if follow.save
        friend.increment!(:followers_count, 1)
        self.increment!(:followings_count, 1)
      end
    end

    def increment_friends_count
      self.increment!(:friends_count, 1)
    end
  end

  module FriendRole
    def follow(user)
      follow = Follow.new(user_id: user.id, follower_id: self.id)

      if follow.save
        user.increment!(:followers_count, 1)
        self.increment!(:followings_count, 1)
      end
    end

    def increment_friends_count
      self.increment!(:friends_count, 1)
    end
  end

end
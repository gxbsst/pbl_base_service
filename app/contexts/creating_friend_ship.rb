class CreatingFriendShip

  def self.create(listener, params, options = {})
    new(listener, params, options).create
  end

  attr_reader :listener, :options, :params, :errors

  def initialize(listener, params, options = {})
    @listener = listener
    
    @options = options
    @params = params
    @errors = Error.new
  end

  def create
    if params.is_a? Hash
      create_one(params)
    elsif params.is_a? Array
      create_many(params)
    end

    if errors.count > 0
      listener.on_create_error(errors)
    else
      listener.on_create_success
    end

    self
  end

  def create_one(params = {})
    params = ActionController::Parameters.new(params).permit!
    friend_ship = FriendShip.new(params)

    if friend_ship.save

      user = User.find(params[:user_id]).extend(UserRole)
      friend = User.find(params[:friend_id]).extend(FriendRole)

      clone_ship(friend_ship)
      user.follow(friend)
      friend.follow(user)
      user.increment_friends_count
      friend.increment_friends_count
    else
      errors << score.errors
    end

    friend_ship
  end

  def create_many(params = [])
    params.each do |param|
      create_one(param)
    end

    self
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

  class Error < Array; end
end
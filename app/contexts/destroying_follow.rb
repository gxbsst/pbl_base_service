# class DestroyingFollow
#   extend Surrounded::Context
#
#   def self.destroy(listener, follow)
#     new(listener, follow).destroy
#   end
#
#   initialize :listener, :follow
#
#   attr_reader :friends
#   def initialize(listener, follow)
#     @friends = Friend.where(user_id: [follow.user_id, follow.follower_id], friend_id: [follow.user_id, follow.follower_id])
#     super
#   end
#
#   def destroy
#     if follow.destroy
#       @friends.destroy_all if @friends.present?
#     end
#   end
#
#   trigger :destroy
#
# end
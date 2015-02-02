class MessageDeliveryWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :default

  def perform(post_id)
    post = Feeds::Post.find(post_id)
    case post.owner_type
      when 'User'
        follows = Follow.where(user_id: post.owner_id)
        if follows
          follows.each {|follow| deliver(follow.follower_id, post)}
        end
      else
        raise 'Only group and user can receive message'
    end
  end

  private
  def deliver(user_id, post)
    begin
      message = Feeds::Message.where(user_id: user_id, post_id: post.id).first
      unless message
        Feeds::Message.create(post_id: post.id,
                              user_id: user_id)
      end
    rescue => e
      Sidekiq.logger.fatal(e)
    end
  end
end

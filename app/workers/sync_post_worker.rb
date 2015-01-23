class SyncPostWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :default

  def perform(post_id)
    post = Feeds::Post.find(post_id)
    return unless post
    post.sync_derivation
  end
end

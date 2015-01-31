class RemoveReourceIdInFeedsPosts < ActiveRecord::Migration
  def change
    remove_column :feeds_posts, :resource_id
  end
end

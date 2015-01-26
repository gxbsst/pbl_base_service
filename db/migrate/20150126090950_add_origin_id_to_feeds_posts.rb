class AddOriginIdToFeedsPosts < ActiveRecord::Migration
  def change
    add_column :feeds_posts, :origin_id, :uuid
  end
end

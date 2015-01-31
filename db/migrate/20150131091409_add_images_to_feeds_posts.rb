class AddImagesToFeedsPosts < ActiveRecord::Migration
  def change
    add_column :feeds_posts, :images, :text, array: true, default: []
  end
end

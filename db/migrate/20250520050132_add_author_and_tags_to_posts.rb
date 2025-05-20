class AddAuthorAndTagsToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :author_id, :integer
    add_column :posts, :tags, :text
  end
end

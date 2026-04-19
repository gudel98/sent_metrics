class AddTrigramIndexToReviewsContent < ActiveRecord::Migration[8.1]
  def up
    enable_extension 'pg_trgm' unless extension_enabled?('pg_trgm')
    add_index :reviews, :content, opclass: :gin_trgm_ops, using: :gin
  end

  def down
    remove_index :reviews, :content
    disable_extension 'pg_trgm' if extension_enabled?('pg_trgm')
  end
end

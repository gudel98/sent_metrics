class RemoveAppIdIndexFromReviews < ActiveRecord::Migration[8.1]
  def change
    remove_index :reviews, :app_id
  end
end

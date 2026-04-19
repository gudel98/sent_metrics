class AddUniqueIndexToReviews < ActiveRecord::Migration[8.1]
  def change
    add_index :reviews, "app_id, date, rating, country, title, md5(content)", unique: true, name: 'index_reviews_on_unique_attributes'
  end
end

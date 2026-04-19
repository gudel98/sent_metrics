class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.string :app_id, index: true
      t.date :date, index: true
      t.string :country
      t.text :content
      t.integer :rating
      t.string :title

      t.timestamps
    end
  end
end

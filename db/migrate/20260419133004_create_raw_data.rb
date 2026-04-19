class CreateRawData < ActiveRecord::Migration[8.1]
  def change
    create_table :raw_data do |t|
      t.jsonb :payload

      t.timestamps
    end
  end
end

class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.integer :reporter_id, null: false, foreign_key: true
      t.integer :reported_id, null: false, foreign_key: true
      t.integer :content_id, null: false, foreign_key: true
      t.string :content_type, null: false
      t.integer :reason, null: false
      t.boolean :is_checked, null: false, default: false

      t.timestamps
    end
    add_index :reports, :reporter_id
    add_index :reports, :reported_id
    add_index :reports, :content_id
  end
end

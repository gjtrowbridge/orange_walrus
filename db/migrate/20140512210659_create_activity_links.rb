class CreateActivityLinks < ActiveRecord::Migration
  def change
    create_table :activity_links do |t|
      t.string :url
      t.string :description
      t.integer :activity_id

      t.timestamps
    end
    add_index :activity_links, :activity_id
  end
end

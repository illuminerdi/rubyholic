class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :group_id
      t.integer :location_id
      t.string :name
      t.text :description
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end

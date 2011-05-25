class CreateTimeboxes < ActiveRecord::Migration
  def self.up
    create_table :timeboxes do |t|
      t.date :start_date
      t.date :end_date
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :timeboxes
  end
end

class CreateAbsences < ActiveRecord::Migration
  def self.up
    create_table :absences do |t|
      t.date :start_date
      t.date :end_date
      t.integer :supply_id      
      t.timestamps
    end
  end

  def self.down
    drop_table :absences
  end
end

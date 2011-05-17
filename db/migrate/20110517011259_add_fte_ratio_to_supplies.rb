class AddFteRatioToSupplies < ActiveRecord::Migration
  def self.up
    add_column :supplies, :fte_ratio, :decimal
    Supply.all.each { |s| s.update_attribute :fte_ratio, 1 }
  end

  def self.down
    remove_column :supplies, :fte_ratio
  end
end

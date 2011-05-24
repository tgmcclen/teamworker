class AddTeamIdToSupplies < ActiveRecord::Migration
  def self.up
    add_column :supplies, :team_id, :integer
  end

  def self.down
    remove_column :supplies, :team_id
  end
end

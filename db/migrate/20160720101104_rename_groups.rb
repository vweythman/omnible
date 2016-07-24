class RenameGroups < ActiveRecord::Migration
  def change
  	rename_table :groups, :squads
  end
end

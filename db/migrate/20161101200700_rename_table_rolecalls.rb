class RenameTableRolecalls < ActiveRecord::Migration
  def change
    rename_table :rolecalls, :roll_calls
  end
end

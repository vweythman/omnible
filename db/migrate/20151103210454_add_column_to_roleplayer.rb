class AddColumnToRoleplayer < ActiveRecord::Migration
  def change
  	rename_table :roleplayers, :pseudonymings
  	add_column :pseudonymings, :type, :string
  	add_column :pseudonymings, :is_primary, :boolean, :default => :false
  end
end

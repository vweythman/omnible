class RemoveHost < ActiveRecord::Migration
  def change
  	drop_table :hosts
    remove_column :sources, :host_id
  end
end

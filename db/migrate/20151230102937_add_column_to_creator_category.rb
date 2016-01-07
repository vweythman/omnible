class AddColumnToCreatorCategory < ActiveRecord::Migration
  def change
  	  add_column :creator_categories, :agentive, :string, :default => 'by'
  end
end

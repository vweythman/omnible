class AddColumnToCharacters < ActiveRecord::Migration
  def change
  	  add_column :characters, :is_fictional, :boolean, :default => true
  end
end

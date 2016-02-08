class AddItemEditColumns < ActiveRecord::Migration
  def change
  	  add_column :items, :publicity_level, :integer, :default => 0
  	  add_column :items, :editor_level, :integer, :default => 0
  end
end

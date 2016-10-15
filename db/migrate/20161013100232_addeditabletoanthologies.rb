class Addeditabletoanthologies < ActiveRecord::Migration
  def change
    add_column :anthologies, :publicity_level, :integer
    add_column :anthologies, :editor_level, :integer
  end
end

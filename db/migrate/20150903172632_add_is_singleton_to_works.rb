class AddIsSingletonToWorks < ActiveRecord::Migration
  def change
    add_column :works, :is_singleton, :boolean, :default => true
  end
end

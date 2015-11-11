class RemoveAboutFromCharacters < ActiveRecord::Migration
  def change
    remove_column :characters, :about
  end
end

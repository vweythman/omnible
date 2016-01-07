class AddCanConnectToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :can_connect, :boolean, :default => true
  end
end

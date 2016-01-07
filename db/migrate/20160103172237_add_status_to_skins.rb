class AddStatusToSkins < ActiveRecord::Migration
  def change
  	  add_column :skins, :status, :string, :default => 'unpublished'
  end
end

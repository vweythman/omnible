class AddStatusToWorks < ActiveRecord::Migration
  def change
  	  add_column :works, :status, :integer
  end
end

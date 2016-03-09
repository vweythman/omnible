class AddStatusToDescribers < ActiveRecord::Migration
  def change
  	  add_column :works_type_describers, :status, :string
  end
end

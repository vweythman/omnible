class ChangeColumnForPossession < ActiveRecord::Migration
  def change
  	rename_column :possessions, :type, :nature
  end
end

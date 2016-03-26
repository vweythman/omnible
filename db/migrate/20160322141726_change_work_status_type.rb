class ChangeWorkStatusType < ActiveRecord::Migration
  def change
  	change_column :works, :status, :string
  end
end

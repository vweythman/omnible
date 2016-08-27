class RenameWorkOpinionValue < ActiveRecord::Migration
  def change
    change_column :work_opinions, :value, :opinion_value
  end
end

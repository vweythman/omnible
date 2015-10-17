class RemoveRedundantWorkColumns < ActiveRecord::Migration
  def change
    remove_column :works, :is_singleton
    remove_column :works, :is_narrative
  end
end

class AddLabelToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :label, :string
    add_column :groups, :publicity_level, :integer
    add_column :groups, :editor_level, :integer
  end
end

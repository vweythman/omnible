class CreateBranchings < ActiveRecord::Migration
  def change
    create_table :branchings do |t|
      t.string :heading, null: false
      t.belongs_to :parent_node, index: true, foreign_key: true
      t.belongs_to :child_node, index: true, foreign_key: true
    end
  end
end

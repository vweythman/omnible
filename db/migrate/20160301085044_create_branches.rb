class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.string :title
      t.text :content, null: false
      t.belongs_to :story, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

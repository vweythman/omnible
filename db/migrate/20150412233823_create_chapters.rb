class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string :title
      t.text :content
      t.belongs_to :work, index: true
      t.string :about
      t.string :afterward
      t.integer :position

      t.timestamps
    end
  end
end

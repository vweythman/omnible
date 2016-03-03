class CreateStoryRoots < ActiveRecord::Migration
  def change
    create_table :story_roots do |t|
      t.belongs_to :story, index: true, foreign_key: true
      t.belongs_to :trunk, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

class CreateWorkTags < ActiveRecord::Migration
  def change
    create_table :work_tags do |t|
      t.belongs_to :work, index: true
      t.belongs_to :tag, polymorphic: true, index: true

      t.timestamps
    end
  end
end

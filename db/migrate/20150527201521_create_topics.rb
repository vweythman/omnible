class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title
      t.belongs_to :creator, polymorphic: true, index: true
      t.boolean :allow_response, null: false, default: true

      t.timestamps
    end
  end
end

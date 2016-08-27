class CreateTrackings < ActiveRecord::Migration
  def change
    create_table :trackings do |t|
      t.belongs_to :user,    index: true, foreign_key: true
      t.belongs_to :tracked, index: true, polymorphic: true

      t.timestamps null: false
    end
  end
end

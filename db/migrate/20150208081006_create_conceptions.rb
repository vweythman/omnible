class CreateConceptions < ActiveRecord::Migration
  def change
    create_table :conceptions do |t|
      t.belongs_to :work, index: true
      t.belongs_to :concept, index: true

      t.timestamps
    end
  end
end

class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.belongs_to :work, index: true
      t.belongs_to :user, index: true
      t.integer :plot
      t.integer :characterization
      t.integer :writing
      t.integer :overall
      t.text :details

      t.timestamps
    end
  end
end

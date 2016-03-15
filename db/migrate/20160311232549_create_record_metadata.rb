class CreateRecordMetadata < ActiveRecord::Migration
  def change
    create_table :record_metadata do |t|
      t.belongs_to :work, index: true, foreign_key: true
      t.string :key
      t.string :value

      t.timestamps null: false
    end
  end
end

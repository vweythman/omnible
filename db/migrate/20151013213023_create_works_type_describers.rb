class CreateWorksTypeDescribers < ActiveRecord::Migration
  def change
    create_table :works_type_describers do |t|
      t.string :name, :null => false, :unique => true
      t.boolean :is_narrative, :null => false, :default => true
      t.boolean :is_singleton, :null => false, :default => true
      t.string :content_type, :null => false, :default => true

      t.timestamps null: false
      t.boolean :is_record, :null => false, :default => false
      t.boolean :is_creative_expression, :null => false, :default => true
    end
  end
end

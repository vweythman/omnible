class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :reference
      t.belongs_to :host, index: true

      t.timestamps
    end
  end
end

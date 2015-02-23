class CreateRelators < ActiveRecord::Migration
  def change
    create_table :relators do |t|
      t.string :name
      t.string :equiv_name

      t.timestamps
    end
  end
end

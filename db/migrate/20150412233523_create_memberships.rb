class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.belongs_to :group, index: true
      t.belongs_to :character, index: true
      t.string :role

      t.timestamps
    end
  end
end

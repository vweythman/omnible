class MakeMembershipPolymorphic < ActiveRecord::Migration
  def change
    rename_column :memberships, :character_id, :member_id
    add_column :memberships, :member_type, :string
  end
end

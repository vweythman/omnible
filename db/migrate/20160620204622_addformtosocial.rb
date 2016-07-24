class Addformtosocial < ActiveRecord::Migration
  def change
    add_column :social_appearances, :form, :string
  end
end

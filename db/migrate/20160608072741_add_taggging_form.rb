class AddTagggingForm < ActiveRecord::Migration
  def change
    add_column :taggings, :form, :string
  end
end

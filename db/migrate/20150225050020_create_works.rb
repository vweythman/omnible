class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
    	t.string :title
    	t.text   :summary
    	t.belongs_to :user, index: true
		t.timestamps
    end
  end
end

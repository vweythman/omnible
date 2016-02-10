class RemovePolymorphicIndex < ActiveRecord::Migration
  def change
  	remove_index :respondences, name: :index_challenge_responses_on_response_id_and_response_type
  	add_index :respondences, [:response_id]
  end
end

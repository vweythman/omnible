class CreateChallengeResponses < ActiveRecord::Migration
  def change
    create_table :challenge_responses do |t|
      t.belongs_to :caller, polymorphic: true, index: true
      t.belongs_to :response, polymorphic: true, index: true
      t.timestamps
    end
  end
end

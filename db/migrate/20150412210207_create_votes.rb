class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean :up, null: false
      t.references :user, index: true, null: false
      t.references :votable, polymorphic: true, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :votes, :users
    add_index :votes, [:user_id, :votable_type, :votable_id], unique: true
  end
end

class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true, null: false
      t.references :question, index: true
      t.timestamp :sent_at

      t.timestamps null: false
    end
    add_foreign_key :subscriptions, :users
    add_foreign_key :subscriptions, :questions
    
    add_index :subscriptions, [:user_id, :question_id], unique: true
  end
end

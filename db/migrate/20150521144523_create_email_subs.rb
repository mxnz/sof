class CreateEmailSubs < ActiveRecord::Migration
  def change
    create_table :email_subs do |t|
      t.references :user, index: true, null: false
      t.references :question, index: true
      t.timestamp :sent_at

      t.timestamps null: false
    end
    add_foreign_key :email_subs, :users
    add_foreign_key :email_subs, :questions
    
    add_index :email_subs, [:user_id, :question_id], unique: true
  end
end

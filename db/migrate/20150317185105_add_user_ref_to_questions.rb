class AddUserRefToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :user, index: true, null: false
    add_foreign_key :questions, :users
  end
end

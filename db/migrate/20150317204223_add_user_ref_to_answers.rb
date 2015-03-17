class AddUserRefToAnswers < ActiveRecord::Migration
  def change
    add_reference :answers, :user, index: true, null: false
    add_foreign_key :answers, :users
  end
end

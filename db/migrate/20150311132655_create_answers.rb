class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :body, null: false
      t.references :question, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :answers, :questions
  end
end

class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :user, index: true, null: false
      t.references :commentable, polymorphic: true, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :comments, :users
  end
end

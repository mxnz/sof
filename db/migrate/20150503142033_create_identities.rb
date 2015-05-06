class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references :user, index: true
      t.string :uid, null: false
      t.string :provider, null: false
      t.string :confirm_code
      t.string :email

      t.timestamps null: false
    end
    add_foreign_key :identities, :users
    add_index :identities, [:uid, :provider], unique: true
  end
end

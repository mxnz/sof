class AddRatingToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :rating, :integer, null: false, default: 0
  end
end

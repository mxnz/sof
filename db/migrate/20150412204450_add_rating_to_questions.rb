class AddRatingToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :rating, :integer, null: false, default: 0
  end
end

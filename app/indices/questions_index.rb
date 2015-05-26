ThinkingSphinx::Index.define :question, with: :active_record do
  indexes title, sortable: true
  indexes body
  indexes user.email, as: :author, sortable: true

  has user_id, created_at, updated_at
end

ThinkingSphinx::Index.define :question, name: 'full_questions_index', with: :active_record do
  indexes title, sortable: true
  indexes body
  indexes user.email, as: :author, sortable: true
  indexes comments.body, as: :question_comments
  indexes answers.body, as: :answers
  indexes answers.comments.body, as: :answer_comments

  has user_id, created_at, updated_at
end

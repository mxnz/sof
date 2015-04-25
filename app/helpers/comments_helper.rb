module CommentsHelper
  def question_id_of_comment(comment)
    if comment.commentable_type == 'Question'
      comment.commentable_id
    elsif comment.commentable_type == 'Answer'
      comment.commentable.question_id
    end
  end
end

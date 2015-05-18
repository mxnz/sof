class Reputation
  ANSWER_WEIGHT  = 1
  FIRST_ANSWER_WEIGHT = 1
  ANSWER_TO_OWN_QUESTION_WEIGHT = 1

  BEST_ANSWER_WEIGHT = 3

  VOTE_OF_QUESTION_WEIGHT = 2
  VOTE_OF_ANSWER_WEIGHT = 1

  def self.after_answer(answer)
    rating = 0
    rating += ANSWER_WEIGHT
    rating += FIRST_ANSWER_WEIGHT if first?(answer)
    rating += ANSWER_TO_OWN_QUESTION_WEIGHT if to_own_question?(answer)
    rating += BEST_ANSWER_WEIGHT if answer.best?

    answer.destroyed? ? -rating : rating
  end

  def self.after_best_answer(answer)
    answer.best? ? 3 : -3
  end

  def self.after_vote(vote)
    weight = 0
    weight = VOTE_OF_QUESTION_WEIGHT if vote.votable.is_a?(Question)
    weight = VOTE_OF_ANSWER_WEIGHT if vote.votable.is_a?(Answer)
    rating = 0;
    rating = vote.up? ? weight : -weight
    vote.destroyed? ? -rating : rating
  end


  def self.update_after_answer(answer)
    delta_rating = after_answer(answer)
    User.update_counters(answer.user_id, rating: delta_rating)
  end

  private
    def self.first?(answer)
      !answer.question.answers.where("created_at < ?", answer.created_at).any?
    end

    def self.to_own_question?(answer)
      answer.user_id == answer.question.user_id
    end

end

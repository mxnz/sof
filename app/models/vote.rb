class Vote < ActiveRecord::Base
  belongs_to :user, inverse_of: :votes
  belongs_to :votable, polymorphic: true

  attr_readonly :up

  validates :user, :votable, presence: true
  validates :votable_type, inclusion: ['Question', 'Answer']
  validates :up, inclusion: [false, true]
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validate :user_cannot_vote_for_himself

  before_create :change_rating
  before_destroy :rollback_rating

  private
    def user_cannot_vote_for_himself
      if votable && user_id == votable.user_id
        errors.add(:user, "can't vote for himself")
      end
    end

    def change_rating
      klass = Object.const_get votable_type
      if up?
        klass.increment_counter(:rating, votable_id)
      else
        klass.decrement_counter(:rating, votable_id)
      end
    end

    def rollback_rating
      klass = Object.const_get votable_type
      if up?
        klass.decrement_counter(:rating, votable_id)
      else
        klass.increment_counter(:rating, votable_id)
      end
    end
    
end

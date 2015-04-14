class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  attr_readonly :up

  validates :user, :votable, presence: true
  validates :up, inclusion: { in: [false, true] }

  before_create :change_rating
  before_destroy :rollback_rating

  private
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

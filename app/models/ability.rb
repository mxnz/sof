class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    if @user
      user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, [Question, Answer, Comment]
  end

  def user_abilities
    guest_abilities
    can :manage, [Question, Answer, Comment], user_id: @user.id
    can :update_best, Answer do |answer|
      @user.owns?(answer.question)
    end
    can :create, Vote do |vote|
      !@user.owns?(vote.votable)
    end
    can :destroy, Vote, user_id: @user.id
    can :create, EmailSub do |email_sub|
      !@user.subscribed_to?(email_sub.question)
    end
    can :destroy, EmailSub, user_id: @user.id
  end
end

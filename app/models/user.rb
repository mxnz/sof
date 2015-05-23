class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions, dependent: :destroy, inverse_of: :user
  has_many :answers, dependent: :destroy, inverse_of: :user
  has_many :votes, dependent: :destroy, inverse_of: :user
  has_many :comments, dependent: :destroy, inverse_of: :user
  has_many :identities, dependent: :destroy, inverse_of: :user
  has_many :email_subs, dependent: :delete_all, inverse_of: :user

  after_create :subscribe_to_all_questions_digest

  attr_accessor :without_password

  def password_required?
    super && !without_password
  end

  def owns?(obj)
    obj.user_id == self.id
  end  

  def voted_on?(votable)
    vote_of(votable).present?
  end

  def vote_of(votable)
    votes.find do |v|
      v.votable_id == votable.id &&
      v.votable_type == votable.class.name
    end
  end

  def subscribed_to?(question)
    return false unless question.is_a? Question
    email_subs.any? { |es| es.question_id == question.id }
  end

  def self.from_omniauth(auth)
    identity = Identity.includes(:user).find_or_create_by(uid: auth.uid, provider: auth.provider)
    return identity.user if identity.user.present?
    
    if auth.info.email.present?
      user = User.find_by(email: auth.info.email)
      unless user.present?
        user = User.new(email: auth.info.email)
        user.without_password = true
        user.save!
      end
      identity.update!(user: user)
      return user
    end
    
    user = User.new
    user.identities << identity
    user
  end

  private 
    def subscribe_to_all_questions_digest
      self.email_subs.create(question: nil)
    end
end

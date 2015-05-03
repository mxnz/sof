class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many :questions, dependent: :destroy, inverse_of: :user
  has_many :answers, dependent: :destroy, inverse_of: :user
  has_many :votes, dependent: :destroy, inverse_of: :user
  has_many :comments, dependent: :destroy, inverse_of: :user
  has_many :identities, dependent: :destroy, inverse_of: :user

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

  def self.from_omniauth(auth)
    identity = Identity.includes(:user).find_or_create_by(uid: auth.uid, provider: auth.provider)
    return identity.user if identity.user.present?
    
    if auth.info.email.present?
      user = User.find_by(email: auth.info.email)
      user = User.create(email: auth.info.email, password: SecureRandom.hex) unless user.present?
      identity.update!(user: user)
      return user
    end
    
    user = User.new
    user.identities.add(identity)
    user
  end

end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions, dependent: :destroy, inverse_of: :user
  has_many :answers, dependent: :destroy, inverse_of: :user

  def owns?(obj)
    obj.user_id == self.id
  end  
end

class Identity < ActiveRecord::Base
  belongs_to :user, inverse_of: :identities

  validates :user, :uid, :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }
end

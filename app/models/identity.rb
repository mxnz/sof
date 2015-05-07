class Identity < ActiveRecord::Base
  belongs_to :user, inverse_of: :identities

  validates :uid, :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }
end

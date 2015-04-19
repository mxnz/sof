module Attachable
  extend ActiveSupport::Concern

  included do
    has_many :attachments, dependent: :destroy, as: :attachable
    accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank
  end
end

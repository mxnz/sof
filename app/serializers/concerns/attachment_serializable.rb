module AttachmentSerializable
  extend ActiveSupport::Concern

  included do
    has_many :attachments

    def attachments
      object.attachments.map { |a| a.file.url }
    end
  end
end

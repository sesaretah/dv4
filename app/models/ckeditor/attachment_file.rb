# frozen_string_literal: true

class Ckeditor::AttachmentFile < Ckeditor::Asset
  has_one_attached :data

  validate :data_presence
  validate :data_size

  def url_thumb
    if data.image?
      Rails.application.routes.url_helpers.rails_representation_url(data.variant(resize_to_limit: [100, 100]))
    else
      Ckeditor::Utils.filethumb(data.filename.to_s)
    end
  end

  private

  def data_presence
    errors.add(:data, "must be attached") unless data.attached?
  end

  def data_size
    if data.attached? && data.byte_size > 100.megabytes
      errors.add(:data, "size exceeds the 100MB limit")
    end
  end
end

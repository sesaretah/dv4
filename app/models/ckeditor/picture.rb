# frozen_string_literal: true

class Ckeditor::Picture < Ckeditor::Asset
  has_one_attached :data

  validate :data_presence
  validate :data_size
  validate :data_content_type

  def url_content
    if data.attached?
      Rails.application.routes.url_helpers.rails_representation_url(
        data.variant(resize_to_limit: [800, 800]), only_path: true
      )
    end
  end

  def url_thumb
    if data.attached?
      Rails.application.routes.url_helpers.rails_representation_url(
        data.variant(resize_to_limit: [118, 100]), only_path: true
      )
    end
  end

  private

  def data_presence
    errors.add(:data, "must be attached") unless data.attached?
  end

  def data_size
    if data.attached? && data.byte_size > 2.megabytes
      errors.add(:data, "size exceeds the 2MB limit")
    end
  end

  def data_content_type
    if data.attached? && !data.content_type.match?(%r{\Aimage/.*\z})
      errors.add(:data, "must be an image")
    end
  end
end
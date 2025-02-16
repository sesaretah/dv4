class Upload < ApplicationRecord
  # Attachments using Active Storage
  has_one_attached :attachment

  # Associations
  belongs_to :uploadable, polymorphic: true, optional: true
  belongs_to :article, class_name: "Article", foreign_key: "uploadable_id", optional: true

  # Validations (similar to Paperclip)
  validate :validate_attachment_content_type

  # Rename the uploaded file before saving
  before_save :rename_attachment

  # Resize images (only applies if the uploaded file is an image)
  before_save :resize_images

  def rename_attachment
    return unless attachment.attached?

    extension = File.extname(attachment.filename.to_s).downcase
    new_filename = "#{Time.now.to_i}#{extension}"
    attachment.blob.update!(filename: new_filename)
  end

  def image?
    attachment.attached? && attachment.content_type.match?(%r{^image/(bmp|gif|jpeg|jpg|pjpeg|png|x-png|tif|tiff)$})
  end

  private

  def validate_attachment_content_type
    allowed_types = [
      "image/jpg", "image/jpeg", "image/png", "image/tiff", "image/gif",
      "application/pdf", "application/vnd.ms-excel",
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      "application/msword",
      "application/vnd.openxmlformats-officedocument.presentationml.presentation",
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
      "text/plain", "audio/webm", "video/webm"
    ]
    if attachment.attached? && !allowed_types.include?(attachment.content_type)
      errors.add(:attachment, "is not a valid file type")
    end
  end

  def resize_images
    return unless image?

    attachment.variant(resize_to_limit: [600, 600]) if attachment.present?
  end

  def extract_text
    return unless uploadable_type == "Article"

    article = Article.find_by(id: uploadable_id)
    return unless article

    article.document_contents = ""

    article.uploads.each do |upload|
      next unless upload.attachment.attached?

      extracted_text = `java -jar #{Rails.root}/lib/tika-app-1.20.jar -h #{upload.attachment.service_url}`
      article.document_contents += " #{extracted_text}" unless extracted_text.blank?
    end

    article.save
  end
end
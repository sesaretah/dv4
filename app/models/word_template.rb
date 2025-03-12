class WordTemplate < ApplicationRecord
  has_one_attached :document

  belongs_to :user
  belongs_to :workflow

  before_save :rename_document, if: -> { document.attached? }

  private

  def rename_document
    if document.attached?
      extension = File.extname(document.filename.to_s).downcase
      new_filename = "#{Time.now.to_i}#{extension}"

      document.blob.update!(filename: new_filename)
    end
  end
end

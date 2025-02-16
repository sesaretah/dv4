class Profile < ApplicationRecord
  include ActionView::Helpers::TextHelper
  after_save ThinkingSphinx::RealTime.callback_for(:profile)

  has_one_attached :avatar
  has_one_attached :signature

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :ratio, :caller
  after_commit :reprocess_avatar, if: :cropping?

  before_destroy :delete_contributions

  has_many :articles, through: :contributions
  has_many :contributions, dependent: :destroy

  has_many :profile_groups, through: :profile_groupings
  has_many :profile_groupings, dependent: :destroy

  belongs_to :user

  # Returns the avatar URL with variants
  def avatar_url(style = :original)
    return unless avatar.attached?

    case style
    when :medium
      avatar.variant(resize_to_limit: [140, 140]).processed.url
    when :tiny
      avatar.variant(resize_to_limit: [20, 20]).processed.url
    when :thumb
      avatar.variant(resize_to_limit: [35, 35]).processed.url
    when :large
      avatar.variant(resize_to_limit: [500, 500]).processed.url
    else
      avatar.url
    end
  end

  # Returns the signature URL with variants
  def signature_url(style = :original)
    return unless signature.attached?

    case style
    when :medium
      signature.variant(resize_to_limit: [200, 200]).processed.url
    when :tiny
      signature.variant(resize_to_limit: [20, 20]).processed.url
    when :thumb
      signature.variant(resize_to_limit: [35, 35]).processed.url
    when :large
      signature.variant(resize_to_limit: [500, 500]).processed.url
    else
      signature.url
    end
  end

  # Merges two profiles by transferring contributions and deleting the second profile
  def self.merge_profile(profile_1, profile_2)
    profile_2.contributions.update_all(profile_id: profile_1.id)
    profile_2.destroy
  end

  # Deletes all contributions linked to this profile before destruction
  def delete_contributions
    contributions.destroy_all
  end

  # Returns full name
  def fullname
    "#{name} #{surename}"
  end

  def title
    fullname
  end

  # Checks if cropping is needed
  def cropping?
    crop_x.present? && crop_y.present? && crop_w.present? && crop_h.present?
  end

  # Returns avatar dimensions
  def avatar_geometry(style = :original)
    return unless avatar.attached?

    file = avatar.variant(resize_to_limit: [500, 500]).processed if style != :original
    image = MiniMagick::Image.open(file&.service_url || avatar.service_url)
    { width: image.width, height: image.height }
  end

  # Generates a profile tag with avatar
  def profile_tag
    "<span class='tag' data-toggle='tooltip' data-placement='top' title='#{fullname}'>
      <span class='tag-avatar avatar' style='background-image: url(#{avatar_url(:tiny)})'></span>
      #{truncate(fullname, length: 15)}
    </span>".html_safe
  end

  private

  # Crops the avatar using Active Storage variants instead of modifying the file
  def reprocess_avatar
    return unless cropping? && avatar.attached?

    variant = avatar.variant(
      crop: "#{crop_w}x#{crop_h}+#{crop_x}+#{crop_y}"
    )
    variant.processed # Ensures variant is processed without modifying the original
  end
end
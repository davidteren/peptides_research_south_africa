class Stack < ApplicationRecord
  validates :slug, :name, presence: true
  validates :slug, uniqueness: true

  scope :public_index, -> { where(origin: %w[vendor_named commonly_reported]) }

  def to_param
    slug
  end
end

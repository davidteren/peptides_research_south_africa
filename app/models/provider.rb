class Provider < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :slug, :name, presence: true
  validates :slug, uniqueness: true

  scope :public_index, -> { where(status: "active") }

  def to_param
    slug
  end
end

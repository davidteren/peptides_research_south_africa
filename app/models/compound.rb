class Compound < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :slug, :name, presence: true
  validates :slug, uniqueness: true

  scope :public_index, -> { where.not(confidence: "rumour") }

  def to_param
    slug
  end
end

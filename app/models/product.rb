class Product < ApplicationRecord
  belongs_to :compound
  belongs_to :provider

  validates :slug, :title_on_page, presence: true
  validates :slug, uniqueness: true

  def to_param
    slug
  end
end

class Team < ApplicationRecord
  include GenerateSlug
  extend FriendlyId

  before_validation :generate_slug

  has_many :members, dependent: :nullify

  friendly_id :slug, use: [:finders]

  validates :name, :slug, presence: true
  validates :name, :slug, presence: true, uniqueness: { case_sensitive: false }
end

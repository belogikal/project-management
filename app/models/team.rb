class Team < ApplicationRecord
  include GenerateSlug

  before_validation :generate_slug

  has_many :members, dependent: :nullify

  validates :name, :slug, presence: true
  validates :name, :slug, presence: true, uniqueness: { case_sensitive: false }
end

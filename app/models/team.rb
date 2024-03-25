class Team < ApplicationRecord
  include GenerateSlug

  before_validation :generate_slug

  has_many :members, dependent: :nullify

  validates :name, :slug, presence: true
end

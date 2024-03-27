class Project < ApplicationRecord
  include GenerateSlug
  extend FriendlyId

  before_validation :generate_slug

  has_many :project_members, dependent: :destroy
  has_many :members, through: :project_members

  friendly_id :slug, use: [:finders]

  validates :name, :slug, presence: true
  validates :name, :slug, presence: true, uniqueness: { case_sensitive: false }
end

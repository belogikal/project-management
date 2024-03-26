class Project < ApplicationRecord
  include GenerateSlug

  before_validation :generate_slug

  has_many :project_members, dependent: :destroy
  has_many :members, through: :project_members

  validates :name, :slug, presence: true
  validates :name, :slug, presence: true, uniqueness: { case_sensitive: false }
end

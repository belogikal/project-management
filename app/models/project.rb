class Project < ApplicationRecord
  has_many :project_members, dependent: :destroy
  has_many :members, through: :project_members

  validates :name, :slug, presence: true
end

class Member < ApplicationRecord
  belongs_to :team
  has_many :project_members, dependent: :destroy
  has_many :projects, through: :project_members

  validates :first_name, :last_name, presence: true
end

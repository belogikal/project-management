class Member < ApplicationRecord
  belongs_to :team
  has_many :project_members, dependent: :destroy
  has_many :projects, through: :project_members
end

class ProjectMember < ApplicationRecord
  belongs_to :member
  belongs_to :project

  validates :project_id, uniqueness: { scope: :member_id }
end

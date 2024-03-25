class Team < ApplicationRecord
  has_many :members, dependent: :nullify

  validates :name, :slug, presence: true
end

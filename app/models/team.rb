class Team < ApplicationRecord
  has_many :members, dependent: :nullify
end

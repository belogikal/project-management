class AddTeamIdToMember < ActiveRecord::Migration[7.1]
  def change
    add_reference :members, :team, foreign_key: true
  end
end

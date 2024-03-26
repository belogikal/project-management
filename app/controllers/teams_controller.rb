class TeamsController < ApplicationController
  include ResourceCrud

  before_action :find_team, only: [:members]

  def members
    @resources = @team.members

    respond_to do |format|
      format.html
      format.json
    end
  end

  def permitted_params
    [:name]
  end

  private

  def find_team
    @team = Team.includes(:members).find(params[:id])
  end
end

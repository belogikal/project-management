class TeamsController < ApplicationController
  include ResourceCrud

  before_action :find_team, only: [:members]

  def members
    respond_to do |format|
      format.html
      format.json { render json: @team.members }
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

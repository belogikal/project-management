class MembersController < ApplicationController
  include ResourceCrud

  def permitted_params
    %i[first_name last_name city state country team_id]
  end
end

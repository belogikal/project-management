class ProjectsController < ApplicationController
  include ResourceCrud

  def members
    respond_to do |format|
      format.html
      format.json { render json: project.members }
    end
  end

  def assign_member
    @project = Project.find(params[:project_id])
    member = Member.find(member_id)

    @project.project_members.build(member: member)
  
    if @project.save
      respond_to do |format|
        format.html { redirect_to redirect_to_path, notice: 'Member added successfully' }
        format.json { render json: { message: 'Member added successfully' } }
      end
    else
      error_response(@project)
    end
  end

  def permitted_params
    [:name]
  end

  private

  def member_id
    params.require(:member_id)
  end

  def project
    @project ||= Project.find(params[:project_id])
  end
end

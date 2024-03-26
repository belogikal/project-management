require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  describe 'POST /projects' do
    it 'creates a project' do
      project_params = { name: 'test project' }
      post '/projects', params: { project: project_params }, as: :json

      expect(response).to have_http_status(200)
      expect(Project.count).to eq(1)
      expect(Project.last.name).to eq('test project')
    end

    it 'returns 422 if name is missing' do
      post '/projects', params: { project: { name: nil } }, as: :json

      expect(response).to have_http_status(422)
      expect(Project.count).to eq(0)
    end
  end

  describe 'GET /projects' do
    let!(:project) { Fabricate(:project) }

    it 'lists all projects' do
      get '/projects', as: :json

      body = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(body).to be_an_instance_of(Array)
      expect(body.count).to be > 0
    end
  end

  describe 'GET /projects/:id' do
    let!(:project) { Fabricate(:project) }

    it 'Shows a project' do
      get "/projects/#{project.id}", as: :json

      body = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(body).to be_an_instance_of(Hash)
      expect(body['id']).to eq(project.id)
    end

    it 'Shows a project - finds the project with slug' do
      get "/projects/#{project.slug}", as: :json

      body = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(body).to be_an_instance_of(Hash)
      expect(body['id']).to eq(project.id)
    end

    it 'returns 404 if project not found' do
      get '/projects/99999', as: :json

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)['error']).to eq('Record not found')
    end
  end

  describe 'PATCH /projects/:id' do
    let!(:project) { Fabricate(:project) }

    it 'updates a project' do
      patch "/projects/#{project.id}", params: { project: { name: 'Test Project' } }, as: :json

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['resource']['name']).to eq('Test Project')
    end

    it 'returns 404 if project not found' do
      patch '/projects/99999', params: { project: { name: 'Test Project' } }, as: :json

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)['error']).to eq('Record not found')
    end
  end

  describe 'DELETE /projects/:id' do
    let!(:project) { Fabricate(:project) }

    it 'deletes a project' do
      count_before_deleting = Project.count
      delete "/projects/#{project.id}", as: :json

      expect(response).to have_http_status(302)
      expect(Project.count).to eq(count_before_deleting - 1)
    end

    it 'returns 404 if project not found' do
      delete '/projects/99999', as: :json

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)['error']).to eq('Record not found')
    end
  end

  describe 'GET /projects/:project_id/members' do
    let!(:project) { Fabricate(:project) }
    let!(:member) { Fabricate(:member) }
    let!(:project_member) { Fabricate(:project_member, project:, member:) }

    it 'lists all members for a project' do
      get "/projects/#{project.id}/members", as: :json

      body = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(body).to be_an_instance_of(Array)
      expect(body.last['id']).to eq(member.id)
    end

    it 'returns 404 if project not found' do
      get '/projects/999999/members', as: :json

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)['error']).to eq('Record not found')
    end
  end

  describe 'PATCH /projects/:project_id/member' do
    let!(:project) { Fabricate(:project) }
    let!(:member) { Fabricate(:member) }

    it 'assigns the project to member' do
      project_members_count_before = project.members.count
      patch "/projects/#{project.id}/member", params: { member_id: member.id }, as: :json

      expect(project.reload.members.count).to eq(project_members_count_before + 1)
    end
  end
end

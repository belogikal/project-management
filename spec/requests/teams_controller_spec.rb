require 'rails_helper'

RSpec.describe 'Teams', type: :request do
  describe 'POST /teams' do
    it 'creates a team' do
      team_params = { name: 'Test Team' }
      post '/teams', params: { team: team_params }, as: :json

      expect(response).to have_http_status(200)
      expect(Team.count).to eq(1)
      expect(Team.last.name).to eq('Test Team')
    end

    it 'returns 422 if name is missing' do
      post '/teams', params: { team: { name: nil } }, as: :json

      expect(response).to have_http_status(422)
      expect(Team.count).to eq(0)
    end
  end

  describe 'GET /teams' do
    let!(:team) { Fabricate(:team) }

    it 'get all teams' do
      get '/teams', as: :json

      body = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(body).to be_an_instance_of(Array)
      expect(body.count).to be > 0
    end
  end

  describe 'GET /teams/:id' do
    let(:team) { Fabricate(:team) }

    it 'Show a team' do
      get "/teams/#{team.id}", as: :json

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['id']).to eq(team.id)
    end

    it 'Show a team - finds the team with slug' do
      get "/teams/#{team.slug}", as: :json

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['id']).to eq(team.id)
    end

    it 'returns 404 if team not found' do
      get '/teams/invalid', as: :json

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)['error']).to eq('Record not found')
    end
  end

  describe 'PUT /teams/:id' do
    let!(:team) { Fabricate(:team) }

    it 'updates a team' do
      put "/teams/#{team.id}", params: { team: { name: 'New Name' } }, as: :json

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['resource']['name']).to eq('New Name')
    end

    it 'returns 404 if team not found' do
      put '/teams/invalid', params: { team: { name: 'New Name' } }, as: :json

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)['error']).to eq('Record not found')
    end
  end

  describe 'DELETE /teams/:id' do
    let!(:team) { Fabricate(:team) }

    it 'deletes a team' do
      team_count_before = Team.count

      delete "/teams/#{team.id}", as: :json

      expect(response).to have_http_status(302)
      expect(Team.count).to eq(team_count_before - 1)
    end

    it 'returns 404 if team not found' do
      delete '/teams/invalid', as: :json

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)['error']).to eq('Record not found')
    end
  end

  describe 'GET /teams/:team_id/members' do
    let!(:team) { Fabricate(:team) }
    let!(:member) { Fabricate(:member, team:) }

    it 'gets all members for a team' do
      get "/teams/#{team.id}/members", as: :json

      body = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(body).to be_an_instance_of(Array)
      expect(body.last['id']).to eq(member.id)
    end

    it 'returns 404 if team not found' do
      get '/teams/invalid/members', as: :json

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)['error']).to eq('Record not found')
    end
  end
end

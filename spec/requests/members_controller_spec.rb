require 'rails_helper'

RSpec.describe 'Members', type: :request do
  let(:team) { Fabricate(:team) }

  describe 'POST /members' do
    it 'creates a member' do
      member_params = { member: { first_name: 'Test', last_name: 'User', team_id: team.id } }

      post '/members', params: member_params, as: :json

      expect(response).to have_http_status(200)
      expect(Member.count).to eq(1)
      expect(Member.last.first_name).to eq('Test')
    end

    it 'returns an error when required params are missing' do
      member_params = { member: { first_name: nil } }

      post '/members', params: member_params, as: :json

      expect(response).to have_http_status(422)
      expect(Member.count).to eq(0)
    end
  end

  describe 'GET /members' do
    let!(:member) { Fabricate(:member) }

    it 'lists all members' do
      get '/members', as: :json

      body = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(body).to be_an_instance_of(Array)
      expect(body.count).to be > 0
    end
  end

  describe 'GET /members/:id' do
    let!(:member) { Fabricate(:member) }

    it 'Show a member' do
      get "/members/#{member.id}", as: :json

      body = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(body).to be_an_instance_of(Hash)
      expect(body['id']).to eq(member.id)
    end

    it 'returns a not found error when member does not exist' do
      get '/members/9999', as: :json

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)['error']).to eq('Record not found')
    end
  end

  describe 'PATCH /members/:id' do
    let(:member) { Fabricate(:member) }

    it 'updates a member' do
      patch "/members/#{member.id}", params: { member: { first_name: 'New' } }, as: :json

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['resource']['first_name']).to eq('New')
    end

    it 'returns a not found error when member does not exist' do
      patch '/members/9999', params: { member: { first_name: 'New' } }, as: :json

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)['error']).to eq('Record not found')
    end
  end

  describe 'DELETE /members/:id' do
    let!(:member) { Fabricate(:member) }

    it 'deletes a member' do
      count_before_deleting = Member.count

      delete "/members/#{member.id}", as: :json

      expect(response).to have_http_status(302)
      expect(Member.count).to eq(count_before_deleting - 1)
    end

    it 'returns a not found error when member does not exist' do
      delete '/members/9999'

      expect(response).to have_http_status(404), as: :json
      expect(JSON.parse(response.body)['error']).to eq('Record not found')
    end
  end
end

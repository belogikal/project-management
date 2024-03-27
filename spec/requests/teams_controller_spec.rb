require 'swagger_helper'

RSpec.describe 'Teams', type: :request do
  path '/teams' do
    post 'Creates a team' do
      tags 'Teams'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :team, in: :body, schema: {
                                          type: :object,
                                          properties: {
                                            name: { type: :string }
                                          },
                                          required: ['name']
                                        },
                required: true,
                description: 'Team attributes',
                example: {
                  name: 'Test Team'
                }

      let(:team) { { name: 'Test Team' } }

      response '200', 'team created' do
        run_test! do
          expect(response).to have_http_status(200)
          expect(Team.count).to eq(1)
          expect(Team.last.name).to eq('Test Team')
        end
      end

      response '422', 'name must exist' do
        let(:team) { { name: nil } }
        run_test! do
          expect(response).to have_http_status(422)
          expect(Team.count).to eq(0)
        end
      end
    end

    get 'Retrieves all teams' do
      let!(:team) { Fabricate(:team) }

      tags 'Teams'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'retrieves all the teams' do
        run_test! do
          body = JSON.parse(response.body)
          expect(response).to have_http_status(200)
          expect(body.count).to be > 0
        end
      end
    end
  end

  path '/teams/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieves a team' do
      tags 'Teams'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      let(:id) { Fabricate(:team).id }

      response '200', 'team found' do
        run_test! do
          expect(response).to have_http_status(200)
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)['id']).to eq(id)
        end
      end

      response '404', 'team not found' do
        let(:id) { 'invalid' }
        run_test! do
          expect(response).to have_http_status(404)
          expect(JSON.parse(response.body)['error']).to eq('Record not found')
        end
      end
    end

    put 'Updates a team' do
      tags 'Teams'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :team, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      let(:id) { Fabricate(:team).id }
      let(:team) { { name: 'New Name' } }

      response '200', 'team updated' do
        run_test! do
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)['resource']['name']).to eq('New Name')
        end
      end

      response '404', 'team not found' do
        let(:id) { 'invalid' }
        run_test! do
          expect(response).to have_http_status(404)
          expect(JSON.parse(response.body)['error']).to eq('Record not found')
        end
      end
    end

    delete 'Deletes a team' do
      let!(:team) { Fabricate(:team) }

      tags 'Teams'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      let(:id) { team.id }

      response '302', 'team deleted' do
        run_test! do
          expect(response).to have_http_status(302)
        end
      end

      response '404', 'team not found' do
        let(:id) { 'invalid' }
        run_test! do
          expect(response).to have_http_status(404)
        end
      end
    end
  end

  path '/teams/{team_id}/members' do
    parameter name: :team_id, in: :path, type: :integer

    get 'Retrieves all members for a particular team' do
      let!(:team) { Fabricate(:team) }
      let!(:member) { Fabricate(:member, team:) }
      let(:team_id) { team.id }

      tags 'Teams'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'lists all members for a team' do
        run_test! do
          body = JSON.parse(response.body)
          expect(response).to have_http_status(200)
          expect(body.last['id']).to eq(member.id)
        end
      end

      response '404', 'team not found' do
        let(:team_id) { 'invalid' }
        run_test! do
          expect(response).to have_http_status(404)
          expect(JSON.parse(response.body)['error']).to eq('Record not found')
        end
      end
    end
  end
end

require 'swagger_helper'

RSpec.describe 'Members', type: :request do
  path '/members' do
    post 'Creates a member' do
      tags 'Members'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :member, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
          last_name: { type: :string },
          city: { type: :string },
          state: { type: :string },
          country: { type: :string },
          team_id: { type: :integer }
        },
        required: %w[first_name last_name team_id]
      }, required: true

      response '200', 'member created' do
        let(:team) { Fabricate(:team) }
        let!(:member) { { first_name: 'Test', last_name: 'Name', team_id: team.id } }

        run_test! do
          expect(response).to have_http_status(200)
          expect(Member.count).to eq(1)
          expect(Member.last.last_name).to eq('Name')
        end
      end

      response '422', 'first_name must exist' do
        let(:member) { { first_name: nil } }
        run_test! do
          expect(response).to have_http_status(422)
          expect(Member.count).to eq(0)
        end
      end
    end

    get 'Retrieves all teams' do
      let!(:member) { Fabricate(:member) }

      tags 'Members'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'retrieves all the members' do
        run_test! do
          body = JSON.parse(response.body)
          expect(response).to have_http_status(200)
          expect(body.count).to be > 0
        end
      end
    end
  end

  path '/members/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieves a member' do
      tags 'Members'
      consumes 'application/json'
      produces 'application/json'

      let(:id) { Fabricate(:member).id }

      response '200', 'member found' do
        run_test! do
          expect(response).to have_http_status(200)
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)['id']).to eq(id)
        end
      end

      response '404', 'member not found' do
        let(:id) { 'invalid' }
        run_test! do
          expect(response).to have_http_status(404)
          expect(JSON.parse(response.body)['error']).to eq('Record not found')
        end
      end
    end

    put 'Updates a member' do
      tags 'Members'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :member, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string }
        }
      }

      let(:id) { Fabricate(:member).id }
      let(:member) { { first_name: 'Updated' } }

      response '200', 'member updated' do
        run_test! do
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)['resource']['first_name']).to eq('Updated')
        end
      end

      response '404', 'member not found' do
        let(:id) { 'invalid' }
        run_test! do
          expect(response).to have_http_status(404)
          expect(JSON.parse(response.body)['error']).to eq('Record not found')
        end
      end
    end

    delete 'Deletes a member' do
      let!(:member) { Fabricate(:member) }

      tags 'Members'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      let(:id) { member.id }

      response '302', 'member deleted' do
        run_test! do
          expect(response).to have_http_status(302)
        end
      end

      response '404', 'member not found' do
        let(:id) { 'invalid' }
        run_test! do
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end

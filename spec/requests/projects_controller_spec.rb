require 'swagger_helper'

RSpec.describe 'Projects', type: :request do
  path '/projects' do
    post 'Creates a project' do
      tags 'Projects'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :project, in: :body, schema: {
                                             type: :object,
                                             properties: {
                                               name: { type: :string }
                                             },
                                             required: ['name']
                                           },
                required: true,
                description: 'Project attributes',
                example: {
                  name: 'Test Project'
                }

      let(:project) { { name: 'Test Project' } }

      response '200', 'project created' do
        run_test! do
          expect(response).to have_http_status(200)
          expect(Project.last.name).to eq('Test Project')
        end
      end

      response '422', 'name must exist' do
        let(:project) { { name: nil } }
        run_test! do
          expect(response).to have_http_status(422)
          expect(Project.count).to eq(0)
        end
      end
    end

    get 'Retrieves all projects' do
      let!(:projects) { Fabricate(:project) }

      tags 'Projects'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'retrieves all the projects' do
        run_test! do
          body = JSON.parse(response.body)
          expect(response).to have_http_status(200)
          expect(body.count).to be > 0
        end
      end
    end
  end

  path '/projects/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieves a project' do
      tags 'Projects'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      let(:id) { Fabricate(:project).id }

      response '200', 'project found' do
        run_test! do
          expect(response).to have_http_status(200)
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)['id']).to eq(id)
        end
      end

      response '404', 'project not found' do
        let(:id) { 'invalid' }
        run_test! do
          expect(response).to have_http_status(404)
          expect(JSON.parse(response.body)['error']).to eq('Record not found')
        end
      end
    end

    put 'Updates a project' do
      tags 'Projects'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :project, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      let(:id) { Fabricate(:project).id }
      let(:project) { { name: 'New Name' } }

      response '200', 'project updated' do
        run_test! do
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)['resource']['name']).to eq('New Name')
        end
      end

      response '404', 'project not found' do
        let(:id) { 'invalid' }
        run_test! do
          expect(response).to have_http_status(404)
          expect(JSON.parse(response.body)['error']).to eq('Record not found')
        end
      end
    end

    delete 'Deletes a project' do
      let!(:project) { Fabricate(:project) }

      tags 'Projects'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      let(:id) { project.id }

      response '302', 'project deleted' do
        run_test! do
          expect(response).to have_http_status(302)
        end
      end

      response '404', 'project not found' do
        let(:id) { 'invalid' }
        run_test! do
          expect(response).to have_http_status(404)
        end
      end
    end
  end

  path '/projects/{project_id}/members' do
    parameter name: :project_id, in: :path, type: :integer

    get 'Retrieves all members for a particular project' do
      let!(:project) { Fabricate(:project) }
      let!(:member) { Fabricate(:member) }
      let!(:project_member) { Fabricate(:project_member, project:, member:) }
      let(:project_id) { project.id }

      tags 'Projects'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'lists all members for a project' do
        run_test! do
          body = JSON.parse(response.body)
          expect(response).to have_http_status(200)
          expect(body.last['id']).to eq(member.id)
        end
      end

      response '404', 'project not found' do
        let(:project_id) { 'invalid' }
        run_test! do
          expect(response).to have_http_status(404)
          expect(JSON.parse(response.body)['error']).to eq('Record not found')
        end
      end
    end
  end

  path '/projects/{project_id}/member' do
    parameter name: :project_id, in: :path, type: :integer, required: true
    parameter name: :params, in: :body, schema: {
      type: :object,
      required: %w[member_id],
      properties: {
        member_id: {
          type: :integer
        }
      }
    }

    patch 'Assigns a project to a member' do
      tags 'Projects'
      consumes 'application/json'
      produces 'application/json'

      let!(:project) { Fabricate(:project) }
      let!(:member) { Fabricate(:member) }
      let(:project_id) { project.id }

      response '200', 'Project assigned to member successfully' do
        let!(:params) { { member_id: member.id } }

        run_test! do
          expect(project.reload.members.last.id).to eq(member.id)
        end
      end
    end
  end
end

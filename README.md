# Members Project Management

## Requirements
```
Model Specs

Member fields
  - first_name (required)
  - last_name (required)
  - city
  - state
  - country

Team fields

  - name (required)
Project fields

  - name (required)

Associations
  - A member must belong to a team.
  - A member can be optionally assigned to multiple projects.

Exit Criteria

  - API Endpoints to: Create/Update/Delete/Index/Show teams
  - API Endpoints to: Create/Update/Delete/Index/Show members
  - API Endpoints to: Create/Update/Delete/Index/Show projects
  - API Endpoint to: Update the team of a member
  - API Endpoint to: Get the members of a specific team
  - API Endpoint to: Add a member to a project
  - API Endpoint to: Get the members of a specific project

Bonus

  - Add tests
  - Basic UI for the exit criteria above with Rails views
```

## Install
### Clone the repository

```shell
git clone https://github.com/meetcodeman/project-management.git
cd project-management
```
### Dependencies

* `ruby -> 3.1.2 `
* `rails -> 7.1.3`
### Install ruby

Install the right ruby version using [rvm](https://rvm.io/) (it could take a while):

```shell
rvm install 3.1.2
```

### Install dependencies

```shell
bundle install
```

### Setup the database

```shell
rails db:setup
```
## Server

```shell
rails s
```

## API testing using RSwag
##### visit [API docs](http://localhost:3000/api-docs/index.html)

```shell
rake rswag:specs:swaggerize
```

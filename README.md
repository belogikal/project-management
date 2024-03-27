# Members Project Management

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

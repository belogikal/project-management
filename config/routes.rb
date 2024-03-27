Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :members
  resources :teams do
    get 'members', on: :member
  end

  resources :projects do
    resources :members, only: :index, to: 'projects#members'
    resource :member, only: :update, to: 'projects#assign_member'
  end
end

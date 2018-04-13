Rails.application.routes.draw do

  root to: 'welcome#index'


  get '/signup' => 'egov_utils/users#new'

  resources :candidates do
    post :finalize, on: :member
    post :approve, on: :member
    patch :disapprove, on: :member
  end

  resources :entry_tests do
    resources :candidate_entry_tests
    post :evaluate, on: :member
  end

  resources :interviews do
    post :evaluate, on: :member
  end

  resources :candidate_entry_tests, only: [:show]

  resources :contacts

  get '/about' => 'welcome#about', as: :about

  mount EgovUtils::Engine => '/internals'

  require 'sidekiq/web'
  require 'egov_utils/routes/admin_constraint'
  mount Sidekiq::Web => '/sidekiq', constraints: EgovUtils::AdminConstraint.new
end

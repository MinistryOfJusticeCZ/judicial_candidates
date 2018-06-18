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
    post :import_results, on: :member
  end

  resources :interviews do
    resources :candidate_interviews, only: [:index, :update] do
      post :reject_apology, on: :member
      post :accept_apology, on: :member
    end
    post :evaluate, on: :member
  end

  resources :candidate_entry_tests, only: [:show]
  resources :candidate_interviews, only: [:show]

  resources :contacts

  get '/about' => 'welcome#about', as: :about

  mount EgovUtils::Engine => '/internals'

  resources :audits, only: [:index]

  require 'sidekiq/web'
  require 'egov_utils/routes/admin_constraint'
  mount Sidekiq::Web => '/sidekiq', constraints: EgovUtils::AdminConstraint.new
end

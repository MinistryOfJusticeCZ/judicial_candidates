Rails.application.routes.draw do

  root to: 'welcome#index'

  get 'signup' => 'egov_utils/users#new'

  resources :candidates do
    post :finalize, on: :member
    post :approve, on: :member
    post :disapprove, on: :member
  end

  resources :entry_tests do
    resources :candidate_entry_tests
    post :evaluate, on: :member
  end

  resources :interviews
  resources :candidate_entry_tests, only: [:show]

  mount EgovUtils::Engine => '/internals'
end

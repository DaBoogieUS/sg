Sg::Application.routes.draw do

  root 'clients#index'
  get 'log_in' => 'sessions#new', as: 'log_in'
  get 'log_out' => 'sessions#destroy', as: 'log_out'
  get 'create_user' => 'users#new', as: 'create_user'
  resources :pages
  resources :users
  resources :sessions

  resources :materials
  resources :part_types
  resources :panel_models

  resources :clients do
    resources :jobs
  end

  resources :panels do
    resources :parts
  end
  resources :structures do
    resources :panels
  end

  resources :manufacturing_jobs do
    resources :nest_runs
  end
  resources :phases do
    resources :structures
    resources :manufacturing_jobs
  end

  resources :jobs do
    resources :phases
  end

  resources :nest_runs do
    resources :nests
  end
  resources :nests do
    resources :nest_objects
  end
end
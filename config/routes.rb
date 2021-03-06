Rails.application.routes.draw do

  devise_for :users

  devise_scope :user do
    get 'users/:id/saved_search_results', to: 'users#saved_search_results', as: 'saved_search_results_user'
    get 'users/:id/saved_searches', to: 'users#saved_searches', as: 'saved_searches_user'
  end

  namespace :saved_search_results do
    post 'update_link'
    post 'updated'
    post 'denied'
    post 'create'
    delete 'destroy'
  end

  namespace :saved_searches do
    get 'new'
    delete 'destroy'
    post 'viewed'
    post 'refresh'
    get 'redis_info'
    post 'del_redis_key'
  end

  post 'we_work_remotelies', to: 'saved_searches#create'
  post 'jr_dev_jobs_index', to: 'saved_searches#create'

  root to: "static_pages#home"
end
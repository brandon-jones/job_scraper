Rails.application.routes.draw do

  devise_for :users

  devise_scope :user do
    namespace :users do
      scope ':id' do
        get 'saved_search_results', to: 'users#saved_search_results', as: 'saved_search_results_user'
        get 'saved_searches', to: 'users#saved_searches', as: 'saved_searches_user'

        namespace :saved_searches do
          get 'new'
          # get 'index'
          delete 'destroy'
          post 'viewed'
          post 'refresh'
        end

        namespace :saved_search_results do
          # get 'index'
          post 'update_link'
          post 'updated'
          post 'denied'
          post 'create'
          delete 'destroy'
        end
      end
    end

  end

  post 'we_work_remotelies', to: 'saved_searches#create'
  post 'jr_dev_jobs_index', to: 'saved_searches#create'

  root to: "static_pages#home"
end
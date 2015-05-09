Rails.application.routes.draw do

  devise_for :users

  devise_scope :user do
    get 'users/:id/saved_search_results', to: 'users#saved_search_results', as: 'saved_search_results_user'
    get 'users/:id/saved_searches', to: 'users#saved_searches', as: 'saved_searches_user'
  end

  

  post 'update_link_saved_job', to: 'saved_search_results#update_link'
  post 'saved_search_result/updated', to: 'saved_search_results#updated'
  post 'saved_search_result/denied', to: 'saved_search_results#denied'
  post 'we_work_remotelies', to: 'saved_searches#create'
  post 'apply_for_job', to: 'saved_search_results#create'

  root to: "static_pages#home"

  delete 'saved_search_results', to: 'saved_search_results#destroy', as: 'destory_saved_search_results'
  delete 'saved_searchs', to: 'saved_searchs#destroy', as: 'destory_saved_searchs'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

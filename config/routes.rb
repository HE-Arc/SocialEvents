Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'main#index'
  
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }

  resources :users
  resources :events
  
  delete "events" => "events#destroy_all", as: :events_delete
  
  get "import" => "events#import"
  get "import/data/:latitude/:longitude/:key_word" => "events#import_data", :latitude => /[^\/]+/, :longitude => /[^\/]+/
  get "import/verify" => "events#import_verify"
  
  get "main/load/" => "main#load"
  get "main/load/:categories/:cantons/:date/:title/:limit/:offset" => "main#load"
  
  get "profil/load/:user_id/" => "users#load"
  get "profil/load/:user_id/:limit/:offset" => "users#load"

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

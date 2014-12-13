Rails.application.routes.draw do
  api_version(:module => "V1", :header => {:name => "Accept", :value => "application/vnd.ibridgebrige.com; version=1"}) do

    get "skill/categories/:ids", to: "skill/categories#index", constraints: {ids: /.+[,].+/}, defaults: { format: 'json' }
    get "curriculum/subjects/:ids", to: "curriculum/subjects#index", constraints: {ids: /.+[,].+/}, defaults: { format: 'json' }
    get "pbl/projects/:ids", to: "pbl/projects#index", constraints: {ids: /.+[,].+/}, defaults: { format: 'json' }

    resources :users, :defaults => { :format => 'json' }, :id => /.*/
    resources :sessions, defaults: { format: 'json'}, only: %w(create destroy)

    # Skill
    namespace :skill do
      resources :categories, defaults: { format: 'json'}
      resources :sub_categories, defaults: {format: 'json'}
    end

    # Curriculum
    namespace :curriculum do
      resources :phases, defaults: {format: 'json'}
      resources :subjects, defaults: {format: 'json'}
      resources :standards, defaults: {format: 'json'}
    end

    namespace :pbl do
      resources :projects, defaults: {format: 'json'}
      resources :products, defaults: {format: 'json'}
      resources :standard_decompositions, defaults: { format: :json}
      resources :rules, defaults: { format: :json}
    end

    resources :gauges, defaults: { format: :json}
  end

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

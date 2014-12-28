Rails.application.routes.draw do
  api_version(:module => "V1", :header => {:name => "Accept", :value => "application/vnd.ibridgebrige.com; version=1"}) do

    resources :users, :defaults => { :format => 'json' }, :id => /.*/ do
      collection do
        get ":ids", to: "users#index", constraints: {ids: /.+[,].+/}
      end
    end

    resources :sessions, defaults: { format: 'json'}, only: %w(create destroy)

    # Skill
    namespace :skill do
      resources :categories, defaults: { format: 'json'} do
        collection do
          get ":ids", to: "categories#index", constraints: {ids: /.+[,].+/}
        end
      end
      resources :sub_categories, defaults: {format: 'json'} do
        collection do
          get ":ids", to: "sub_categories#index", constraints: {ids: /.+[,].+/}
        end
      end
      resources :techniques, defaults: {format: 'json'} do
        collection do
          get ":ids", to: "techniques#index", constraints: {ids: /.+[,].+/}
        end
      end
    end

    # Curriculum
    namespace :curriculum do
      resources :phases, defaults: {format: 'json'} do
        collection do
          get ":ids", to: "phases#index", constraints: {ids: /.+[,].+/}
        end
      end
      resources :subjects, defaults: {format: 'json'} do
        collection do
          get ":ids", to: "subjects#index", constraints: {ids: /.+[,].+/}
        end
      end
      resources :standards, defaults: {format: 'json'} do
        collection do
          get ":ids", to: "standards#index", constraints: {ids: /.+[,].+/}
        end
      end
      resources :standard_items, defaults: {format: 'json'} do
        collection do
          get ":ids", to: "standard_items#index", constraints: {ids: /.+[,].+/}
        end
      end
    end

    namespace :pbl do
      resources :projects, defaults: {format: 'json'} do
        collection do
          get ":ids", to: "projects#index", constraints: {ids: /.+[,].+/}
        end
        member do
          patch "actions/release", to: "projects#release"
        end
      end
      resources :products, defaults: {format: 'json'}
      resources :standard_decompositions, defaults: { format: :json}
      resources :rules, defaults: { format: :json}
      resources :knowledge, defaults: {format: 'json'}
      resources :tasks, defaults: {format: 'json'}
      resources :disciplines, defaults: {format: 'json'}
      resources :techniques, defaults: { format: :json }, only: %w(index destroy create show)
      resources :standard_items, defaults: { format: :json }, only: %w(index destroy create show)
    end

    resources :gauges, defaults: { format: :json} do
      collection do
        put ":ids/actions/increase", to: "gauges#increase", constraints: {ids: /.+[,].+/}
        put ":ids/actions/decrease", to: "gauges#decrease", constraints: {ids: /.+[,].+/}
        get ":ids", to: "gauges#index", constraints: {ids: /.+[,].+/}
        get 'recommends', to: "gauges#recommends"
      end
      member do
        put "actions/increase", to: "gauges#increase"
        put "actions/decrease", to: "gauges#decrease"
      end
    end

    resources :roles, defaults: { format: :json}

    resources :product_forms, defaults: { format: :json} do
      collection do
        get ":ids", to: "product_forms#index", constraints: {ids: /.+[,].+/}
      end
    end

    resources :assignments, defaults: { format: :json}, only: %w(create destroy index) do
      collection do
        delete ":ids", to: "assignments#destroy", constraints: {ids: /.+[,].+/}
      end
    end

    resources :resources, defaults: { format: :json} do
      collection do
        get ":owner_type/:owner_id", to: "resources#index"
      end
    end

    resources :regions, defaults: { format: :json}
    resources :follows, defaults: {format: :json}

    resources :friends, defaults: {format: :json} do
      collection do
        get ":ids", to: "friends#index", constraints: {ids: /.+[,].+/}
      end
    end

    namespace :group do
      resources :groups, defaults: {format: :json} do
        collection do
          get ":ids", to: "groups#index", constraints: {ids: /.+[,].+/}
        end
      end

      resources :member_ships, defaults: {format: :json}
    end
  end

end

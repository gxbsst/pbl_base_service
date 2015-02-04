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
      resources :tasks, defaults: {format: 'json'} do
        member do
          patch "actions/release", to: "tasks#release"
        end
      end
      resources :disciplines, defaults: {format: 'json'}
      resources :techniques, defaults: { format: :json }, only: %w(index destroy create show)
      resources :standard_items, defaults: { format: :json }, only: %w(index destroy create show)
      resources :discussions, defaults: {format: 'json'}
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
      collection do
        get ":ids", to: "resources#index", constraints: {ids: /.+[,].+/}
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
      resources :posts, defaults: {format: :json}
      resources :replies, defaults: {format: :json}
    end

    resources :comments, defaults: { format: :json} do
      collection do
        get ":ids", to: "comments#index", constraints: {ids: /.+[,].+/}
      end
    end

    resources :notifications, defaults: { format: :json} do
      collection do
        get ":ids", to: "notifications#index", constraints: {ids: /.+[,].+/}
        get :count, to: "notifications#count"
      end
    end

    namespace :assignment do
      resources :works, defaults: { format: :json} do
        collection do
          get ":ids", to: "works#index", constraints: {ids: /.+[,].+/}
        end
      end
      resources :scores, defaults: {format: :json} do
        collection do
          get ":ids", to: "scores#index", constraints: {ids: /.+[,].+/}
        end
      end
    end

    resources :invitations, defaults: { format: :json } do
      collection do
        get ":ids", to: "invitations#index", constraints: {ids: /.+[,].+/}
      end
    end

    resources :schools, defaults: { format: :json } do
      collection do
        get ":ids", to: "schools#index", constraints: {ids: /.+[,].+/}
      end
    end

    resources :grades, defaults: { format: :json } do
      collection do
        get ":ids", to: "grades#index", constraints: {ids: /.+[,].+/}
      end
    end

    resources :clazzs, defaults: { format: :json } do
      collection do
        get ":ids", to: "clazzs#index", constraints: {ids: /.+[,].+/}
      end
    end

    resources :students, defaults: { format: :json } do
      collection do
        get ":ids", to: "students#index", constraints: {ids: /.+[,].+/}
      end
    end

    resources :requests, defaults: { format: :json } do
      collection do
        get ":ids", to: "requests#index", constraints: {ids: /.+[,].+/}
      end
    end

    resources :friend_ships, defaults: { format: :json } do
      collection do
        get ":ids", to: "friend_ships#index", constraints: {ids: /.+[,].+/}
      end
    end

    namespace :feed do
      resources :posts, defaults: { format: :json } do
        get ":ids", to: "posts#index", constraints: {ids: /.+[,].+/}
      end
      resources :messages, defaults: { format: :json } do
        get ":ids", to: "messages#index", constraints: {ids: /.+[,].+/}
      end
    end

    namespace :todo do
      resources :todos, defaults: { format: :json } do
        get ":ids", to: "todos#index", constraints: {ids: /.+[,].+/}
      end
      resources :todo_items, defaults: { format: :json } do
        get ":ids", to: "todo_items#index", constraints: {ids: /.+[,].+/}
        member do
          patch "actions/complete", to: "todo_items#complete"
          patch "actions/cancel_complete", to: "todo_items#cancel_complete"
        end
      end
    end

    resources :mails, defaults: { format: :json }, only: %w(create)
  end

  require "sidekiq/web"
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end if Rails.env.production?
  mount Sidekiq::Web, at: "/sidekiq"

end

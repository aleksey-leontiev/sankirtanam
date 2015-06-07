Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  namespace :api do
    namespace :statistics do
      post 'reports/new'
      get  'permissions/canSendReport'
    end

    get 'locations/index'
  end

  namespace :statistics do
    get 'reports/new'
    get 'reports/overall'
    get 'reports/annual/:year' => 'reports#annual', as: :reports_annual
    get 'reports/location/:location/:year' => 'reports#location', as: :reports_location
    get 'reports/location' => 'reports#location', as: :reports_location_select
    get 'reports/monthly/:location/:year-:month' => 'reports#monthly', as: :reports_monthly
    get 'reports/personal' => 'reports#personal', as: :reports_personal_select
    get 'reports/personal/:id-:name' => 'reports#personal', as: :reports_personal
    get 'reports/personal/:id-:name/:year/:month' => 'reports#personal', as: :reports_personal_month
  end

  devise_for :users

  root 'statistics/reports#overall'

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

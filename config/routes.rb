Ladder8::Application.routes.draw do
  get 'pages/constraints', :as => :constraints
  get 'pages/faq', :as => :faq

  get  'security/code', :as => :code
  post 'security/login', :as => :login
  get  'security/logout', :as => :logout

  root :to => 'games#index'

  with_options :only => [:create, :destroy] do |comment_options|
    resources :games, :only => [:index, :show, :create] do
      comment_options.resources :comments
      resources :sides, :only => [:update], :path_names => {:update => :confirm}
    end

    resources :news do
      comment_options.resources :comments
    end

    resources :players, :except => :destroy, :path_names => {:new => :signup} do
      comment_options.resources :comments
      resources :ratings, :defaults => {:format => :js}, :only => [:index]
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

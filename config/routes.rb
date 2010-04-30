# This file is responsible for the mapping of URLs to the controllers
# that will take action and choose what to display.
# This application has a nested structure, with many resources being
# applicable only in the context of a parent resource.

Tasks::Application.routes.draw do |map|

  # Each 'resources' maps create, read, update, and delete routes for
  #   the corresponding controller. We nest

  resources :users

  # Groups are a little more complex. They have the same basic
  # structure, but have sub-resources, one of which has special actions
  # for ownership management.
  resources :groups do
    # group_users are accessed at /group/:id/group_users/:join_id
    resources :group_users do
      # create direct addresses for making and removing owners.
      post :promote, :on => :member
      post :demote, :on => :member
    end

    # Within each group, we have projects, which in turn have tasks.
    resources :projects do
      resources :tasks
    end
     
          
  end

  # A user's login, or session, is represented as a singleton resource.
  # GET /new for login form, POST to /create to login, and DESTROY to logout.
  resource :user_session

  # A user first coming to the site (/) will see the projects listing.
  root :to => "groups#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications:
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

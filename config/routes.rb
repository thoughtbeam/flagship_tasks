# This file is responsible for the mapping of URLs to the controllers
# that will take action and choose what to display.

Tasks::Application.routes.draw do |map|
  # Each entry maps create, read, update, and delete routes for
  #   the corresponding controller.
  resources :tasks
  resources :projects
  resources :users

  # Groups are a little more complex. They have the same basic
  # structure, but we have a sub-resource, which has special actoins
  # for ownership management.
  resources :groups do
    # group_users are accessed at /group/:id/group_users/:join_id
    resources :group_users do
      # create direct addresses for making and removing owners.
      post :promote, :on => :member
      post :demote, :on => :member
    end
  end

  # A user's login, or session, is represented as a singleton resource.
  # GET /new for login form, POST to /create to login, and DESTROY to logout.
  resource :user_session

  # A user first coming to the site (/) will see the projects listing.
  root :to => "projects#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications:
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

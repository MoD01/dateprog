Dateprog::Application.routes.draw do
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  
  #  scope ':locale', defaults: { locale: I18n.locale } do
  # trying to fix the issue with non switching locale, based on http://iswwwup.com/t/79e2daa8c1e0/locale-not-switching-in-rails-4.html 
  scope ':locale', defaults: { locale: I18n.locale }, constraints: { locale: /en|ru/ } do
    ActiveAdmin.routes(self)
  end   
  
  get '/users/send_invitation/:id', to: 'admin/users#send_invitation', as: 'send_invitation'
  
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', sessions: 'sessions', confirmations: 'confirmations'}
  
  devise_scope :user do
    #get "sign_with_social" => "sessions#sign_with_social", :as => :sign_with_social
    #get "/invitation/confirmation" => "sessions#invitation_confirmation", :as => :invitation_confirmation
    get "/notification/confirmation/:notification_token/:sign_in(/:profile)" => "sessions#notification_confirmation", :as => :notification_confirmation
    #get "/sign-up/:referral_code" => "sessions#invitation_signup", :as => :invitation_signup
  end

  resource :user, only: [:edit] do
    collection do
      patch 'update_password'
      get "report_abuse/:user_id" => "users#report_abuse", :as => :report_abuse
      get "request_profile/:user_id" => "users#request_profile", :as => :request_profile
      get "allow_profile/:user_id" => "users#allow_profile", :as => :allow_profile
      get "allowed_private_profile" => "users#allowed_private_profile", :as => :allowed_private_profile
      get "delete_profile_access/:id" => "users#delete_profile_access", :as => :delete_profile_access
      get "allow_disallow/:id" => "users#allow_disallow", :as => :allow_disallow
      match "/delete/account" => "users#delete_account", :as => :delete_account, :via => [:post]
      get "/read_notifications" => "users#read_notifications", :as => :read_notifications
      get "request_create_course" => "users#request_create_course", :as => :request_create_course
      get "like_dislike/:id", to: "users#like_dislike", :as => :like_dislike
    end
  end

  
  resources :people, :as => :girls, :controller => :girls do
    get :autocomplete_tag_name, :on => :collection
  end
  
  get "/nonprogrammers" => redirect("/people")
  
  get "/show_profile/:id" => "girls#show_profile", :as => :show_profile
  get "/next_users/:page" => "girls#next_users", :as => :next_users
  post "/filter_users" => "girls#filter_users", :as => :filter_users
  get "/profile" => "girls#profile", :as => :profile
  get "/profile/technologies" => "girls#profile_technologies", :as => :profile_technologies
  get "/profile/:id" => "girls#profile_show", :as => :profile_show
  post "/save/profile" => "girls#save_profile", :as => :save_profile
  post "/save/profile_detail" => "girls#save_profile_detail", :as => :save_profile_detail
  post "/save/profile_notification" => "girls#save_profile_notification", :as => :save_profile_notification
  get "/advert/:advert_id" => "girls#advert", :as => :advert
  get "/close_advert" => "girls#close_advert", :as => :close_advert
  get "/discharge_battery" => "girls#discharge_battery", :as => :discharge_battery
  get "/notify_profile" => "girls#notify_profile", :as => :notify_profile
  get "/increase_battery_size/:action_type" => "girls#increase_battery_size", :as => :increase_battery_size
  get "/skip_traits" => "girls#skip_traits", :as => :skip_traits
  
    
  
  resources :programmers
  get "/next_girls/:page" => "programmers#next_girls", :as => :next_girls
  match "/console_girls" => "programmers#console_girls", :as => :console_girls, :via => [:get, :post]
  match "/skills" => "programmers#skills", :as => :skills, :via => [:get, :post]
  match "/skill_question_answers" => "programmers#skill_question_answers", :as => :skill_question_answers, :via => [:get, :post]
  match "/programmer_profile" => "programmers#programmer_profile", :as => :programmer_profile, :via => [:get, :post]
  
    
  resources :messages
  get "/next_messages/:page" => "messages#next_messages", :as => :next_messages
  get "/show_messages/:recipient_id" => "messages#show_messages", :as => :show_messages
  get "/mobile_show_messages/:recipient_id" => "messages#mobile_show_messages", :as => :mobile_show_messages
  get "/show_next_messages/:recipient_id/:page" => "messages#show_next_messages", :as => :show_next_messages
  post "/chat_room" => "messages#chat_room", :as => :chat_room
  get "/close_chat_window/:recipient_id" => "messages#close_chat_window", :as => :close_chat_window
  
  resources :skill_questions

  resources :invites

  resources :courses do
    get "users" => "courses#users", :as => :users
    get "next_users" => "courses#next_users", :as => :next_users
    resources :course_levels
  end
  get "/next_courses/:page" => "courses#next_courses", :as => :next_courses

  resources :tags

  resources :jobs

  namespace :user do
    resources :courses do 
      get :autocomplete_tag_name, :on => :collection
      resources :course_levels
    end

    resources :jobs do 
      get :autocomplete_tag_name, :on => :collection      
    end    
  end

  
  get "/next_jobs/:page" => "jobs#next_jobs", :as => :next_jobs

  get "/home/:page" => "home#static_page", :as => :static_page
  get "/home/dashboard" => "home#dashboard", :as => :home_dashboard
  
  root to: "home#index"
  
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

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :auth do
      #signup routes
      post "signup/request" ,to: "/api/auth#signup_request"
      post "signup/verify" ,to: "/api/auth#email_verify"

      #login routes
      post "login/request" ,to: "/api/auth#login_request"
      post "login/verify" ,to: "/api/auth#login_verify"

      #check email route
      post "check_email", to: "/api/auth#check_email"
      
      #logout route
      post "logout", to: "/api/auth#logout_user"

      # show users
      get ":id",  to: "/api/auth#show"
      get "",  to: "/api/auth#index"
    end
    #create wallet ,list all wallets and show particular wallet
    resources :wallets, only: [:index, :create, :show]
    resources :transfers,only: [:index,:create,:show]
  end
  #health check route
  get "health", to: "healths#index"
  post "health/check", to: "healths#get_data_request"
end

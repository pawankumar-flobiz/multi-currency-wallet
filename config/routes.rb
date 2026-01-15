Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    scope :auth do
      #signup routes
      post "signup/request" , to: "auth#signup_request"
      post "signup/verify" , to: "auth#email_verify"

      #login routes
      post "login/request" , to: "auth#login_request"
      post "login/verify" , to: "auth#login_verify"

      #check email route
      post "check_email", to: "auth#check_email"
      
      #logout route
      post "logout", to: "auth#logout_user"
    end
    #create wallet ,list all wallets and show particular wallet
    resources :wallets, only: [:index, :create, :show]
    resources :transfers,only: [:index,:create,:show]
  end
  #health check route
  get "health", to: "healths#index"
  post "health/check", to: "healths#get_data_request"
end

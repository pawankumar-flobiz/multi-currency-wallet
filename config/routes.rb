Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :auth do
      #signup routes
      post "signup/request" ,to: "signup#request_otp"
      post "signup/verify" ,to: "signup#verify_otp"

      #login routes
      post "login/request" ,to: "login#request_otp"
      post "login/verify" ,to: "login#verify_otp"

      #check email route
      post "check_email", to: "auth#check_email"
      
      #logout route
      post "logout", to: "logout#logout_user"
    end
  end
  #health check route
      get "health", to: "health#index"
      post "health/check", to: "health#dataFromPost"
end

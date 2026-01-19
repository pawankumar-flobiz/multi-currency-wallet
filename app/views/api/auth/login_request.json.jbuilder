json.message "Otp sended successfully on you email verify it"
json.data do
  json.partial! "user", user:@user
end
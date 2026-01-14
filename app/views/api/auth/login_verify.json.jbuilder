json.message "Otp sent successfully please verify it"
json.token @token

json.data do
  json.partial! "user", user:@user
end
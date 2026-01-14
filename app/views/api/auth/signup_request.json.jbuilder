json.message "user created successfully and otp is sended please verify your email"
json.data do
  json.partial! "user", user:@user
end
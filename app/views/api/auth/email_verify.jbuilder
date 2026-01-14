json.message "Email verified successfully!"
json.data do
  json.partial! "user",user:@user
end
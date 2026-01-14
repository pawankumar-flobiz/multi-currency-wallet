json.message "Email exists"
json.data do
  json.partial! "user" , user:@user
end
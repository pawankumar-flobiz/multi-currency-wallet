json.message "User get successfully"
json.data do
  json.partial! "user", user:@user
end
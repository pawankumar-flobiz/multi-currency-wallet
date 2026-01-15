json.message "Users get successfully!"
json.users @users do |user|
  json.partial! "user", user: user
end
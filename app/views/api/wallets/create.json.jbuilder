json.message "Wallets created successfully!"
json.data do
  json.partial! "wallet", wallet:@wallet
end

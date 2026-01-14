json.message "Wallet get successfully"
json.data do
  json.partial! "wallet",wallet:@wallet
end
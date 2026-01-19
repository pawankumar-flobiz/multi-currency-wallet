json.message "Wallets get successfully!"
json.wallets @wallets do |wallet|
  json.partial! "wallet", wallet: wallet
end

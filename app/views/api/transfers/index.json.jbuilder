json.message "Transactions get successfully!"
json.transactions @transactions do |transaction|
  json.partial! "transaction", transaction: transaction
end
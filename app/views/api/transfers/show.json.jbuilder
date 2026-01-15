json.message "Transaction details get successfully"
json.transaction do
  json.partial! "transaction",transaction:@transaction
end
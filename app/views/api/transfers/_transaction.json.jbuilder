json.id transaction.id

json.sender do
  json.id transaction.user_id
  json.name transaction.user.name
end

json.receiver do
  json.id transaction.receiver_id
  json.name transaction.receiver.name
end
json.sender_wallet_id transaction.sender_wallet_id
json.receiver_wallet_id transaction.receiver_wallet_id
json.from_currency transaction.from_currency
json.to_currency transaction.to_currency
json.amount transaction.amount
json.fee transaction.fee
json.exchange_rate transaction.exchange_rate
json.total_debit transaction.total_debit
json.created_at transaction.created_at
json.updated_at transaction.updated_at

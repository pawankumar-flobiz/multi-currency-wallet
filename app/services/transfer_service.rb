class TransferService

  EXCHANGE_FEE_RATE=0.0001

  def self.transfer_money(sender,receiver_id,sender_currency_code,receiver_currency_code,amount)
    
    
    amount=validate_amount(amount)
    validate_sender(sender)
    validate_receiver(receiver_id)
    validate_currency_code(sender_currency_code,receiver_currency_code)
    
    sender_currency_code=sender_currency_code.downcase
    receiver_currency_code=receiver_currency_code.downcase

    #getting real time exchange_rate from exchange service
    exchange_rate = sender_currency_code == receiver_currency_code ? 1 : ExchangeRateService.exchange_rate(from_currency: sender_currency_code,to_currency:receiver_currency_code)
    
    #calculating exchange fee
    fee = sender_currency_code == receiver_currency_code ? 0.to_d : amount * EXCHANGE_FEE_RATE
    
    total_debit= amount + fee;
    #finding receiver details
    receiver=User.find_by!(id:receiver_id)
    transaction=nil
    ActiveRecord::Base.transaction do
      sender_wallet=Wallet.lock.find_by!(user_id: sender.id ,currency_code:sender_currency_code)
      receiver_wallet=Wallet.lock.find_by!(user_id: receiver.id ,currency_code:receiver_currency_code)

      raise ValidationError.new("Money connot be transfers in same wallet ") if sender_wallet.id == receiver_wallet.id
      raise ValidationError.new("Insufficient Balance we cannot be tranfers" ,status:400,code:"INSUFFICIENT_BALANCE") if sender_wallet.balance<total_debit

      #Balance update

      #debit the money from sender wallets
      sender_wallet.update!(balance: sender_wallet.balance - total_debit)

      #credit the money to receiver wallets
      receiver_wallet.update!(balance: receiver_wallet.balance + (amount* exchange_rate))

      # create Transaction
      transaction = Transaction.create!(
        user_id:sender_wallet.user_id,
        receiver_id:receiver_wallet.user_id,
        sender_wallet:sender_wallet,
        receiver_wallet:receiver_wallet,
        amount:amount,
        from_currency:sender_currency_code,
        to_currency:receiver_currency_code,
        total_debit:total_debit,
        fee:fee,
        exchange_rate:exchange_rate
      )
    end

    #sending email notification to sender and receiver
    TransactionNotificationWorker.perform_async(
                                  sender.id,
                                  transaction.id,
                                  "DEBIT"
    )
    TransactionNotificationWorker.perform_async(
                                  receiver.id,
                                  transaction.id,
                                  "CREDIT"
    )
    transaction
  end

  private
  def self.validate_amount(amount)
    raise ValidationError.new(
      "Amount required",
      status: 400,
      code: "INVALID_AMOUNT"
    ) if amount.blank?

    amount = amount.to_d

    raise ValidationError.new(
      "Amount must be greater than 0",
      status: 400,
      code: "NEGATIVE_AMOUNT"
    ) if amount <= 0

    amount
  end

  def self.validate_sender(sender)
    raise ValidationError.new(
      "Sender is required",
      status: 400,
      code: "VALIDATION_ERROR"
    ) if sender.nil?
  end

  def self.validate_receiver(receiver_id)
    raise ValidationError.new(
      "Receiver is required",
      status: 400,
      code: "VALIDATION_ERROR"
    ) if receiver_id.nil?
  end

  def self.validate_currency_code(sender_currency, receiver_currency)
    raise ValidationError.new(
      "Currency codes required",
      status: 400,
      code: "INVALID_CURRENCY"
    ) if sender_currency.blank? || receiver_currency.blank?

    sender_currency   = sender_currency.downcase
    receiver_currency = receiver_currency.downcase

    if !Wallet.currency_codes.key?(sender_currency) || !Wallet.currency_codes.key?(receiver_currency)
      raise ValidationError.new(
        "Invalid currency code",
        status: 400,
        code: "INVALID_CURRENCY"
      )
    end
  end
  
end
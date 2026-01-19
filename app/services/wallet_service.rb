class WalletService

  def self.create_wallet(user:,currency_code:,balance:)
    raise ValidationError.new(
      "currency_code required",
      400,
      "INVALID_CURRENCY_CODE"
    ) if currency_code.blank?

    currency = currency_code.to_s.downcase
    raise ValidationError.new("You reached out the maximum wallets count User can create maximum 5 wallets",status: 400,code:"LIMIT_CROSS") if user.wallets.count >= 5
    
    # checking given code is correct currency_code
    unless Wallet.currency_codes.key?(currency)
      raise ValidationError.new(
        "Invalid currency_code",
        400,
        "INVALID_CURRENCY_CODE"
      )
    end
    
    wallet=nil


    redis_key = "wallet:create:#{user.id}:#{currency}"
    
    raise ValidationError.new("Concurrency conflict occured",status: 429,code:"RACE_CONDITION") unless $redis.set(redis_key,user.id,nx:true,ex:10)
    raise ValidationError.new() if user.wallets.exists?(currency_code:currency) # if already exists same wallet
    begin
      wallet=user.wallets.create!(currency_code:currency,balance:balance || 0)
    rescue ActiveRecord::RecordNotUnique
      raise ValidationError.new("Wallet already exists",status: 400,code:"WALLET_EXISTS")
    ensure
      $redis.del(redis_key) 
    end
    wallet
  end
end
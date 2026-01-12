class WalletService

  def self.create_wallet(user:,currency_code:)
    raise ValidationError.new(
      "currency_code required",
      400,
      "INVALID_CURRENCY_CODE"
    ) if currency_code.blank?

    currency = currency_code.to_s.downcase
    
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

    # 1. Start Watching the key
    $redis.watch(redis_key) do
      if $redis.exists(redis_key) > 0 || user.wallets.exists?(currency_code: currency)
        $redis.unwatch
        raise ValidationError.new("Wallet already exists",code:"WALLET_EXISTS", status: 400)
      end

      # 3. Open the Transaction
      result = $redis.multi do |tx|
        tx.set(redis_key, "created") # Marked created
      end

      if result
        # Only create in DB if Redis successfully "won" the race
        begin
          wallet=user.wallets.create!(currency_code: currency.to_sym, balance: 0)
        rescue ActiveRecord::RecordNotUnique
          raise ApplicationError.new("Wallet already exists (DB)", status: 422)
        end
      else
        # if result is nil means another request modified the key during the watch
        raise ApplicationError.new("Concurrent request detected. Please try again.", status: 409)
      end
    end
  end
end
module Auth
  class JwtService
    SESSION_PREFIX="auth:session"

    # Encode payload into JWT token and store in Redis
    def self.encode(payload)
      payload[:exp]= Time.now.to_i + jwt_expiry
      token=JWT.encode(payload, jwt_secret, 'HS256')
      
      # Store token in Redis
      $redis.set(redis_key(token), payload.to_json, ex: jwt_expiry)
      token
    end

    # Decode JWT token and validate
    def self.decode(token)
      JWT.decode(token, jwt_secret, true, { algorithm: 'HS256' }).first
      rescue JWT::DecodeError 
        raise AuthenticationError.new('Invalid token')
      rescue JWT::ExpiredSignature
        raise AuthenticationError.new('Token has expired')
    end

    # Delete JWT token from Redis
    def self.delete(token)
      $redis.del(redis_key(token))
    end

    # Generate Redis key for storing session
    def self.redis_key(token)
      "#{SESSION_PREFIX}:#{token}"
    end

    # Check if session exists in Redis
    def self.session_exists?(token)
      !!$redis.exists?(redis_key(token))
    end

    private
    # Get JWT secret from settings
    def self.jwt_secret
      Settings.jwt.secret
    end

    # Get JWT expiry from settings
    def self.jwt_expiry
      Settings.jwt.expiry.to_i
    end
  end
end
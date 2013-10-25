require 'rack/attack'

def protect_from_rack_attacks
  use Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  throttle_answers
  lockout_signup
end

def throttle_answers
  # Throttle answer attempts for a given session to 1 req/sec
  # Return the session id as a discriminator on POST /respuestas requests
  Rack::Attack.throttle('answers/session', :limit => 1, :period => 1.seconds) do |req|
    req.env['rack.session'][:csrf] if req.path == '/respuestas' && req.post?
  end
end

def lockout_signup
  # Lockout users that are hammering the signup form.
  # After 3 requests in 1 minute, block all requests from that session for 1 hour.
  Rack::Attack.blacklist('allow2ban signup scrapers') do |req|
    # `filter` returns false value if request is to the signup page (but still
    # increments the count) so request below the limit are not blocked until
    # they hit the limit.  At that point, filter will return true and block.
    uid = req.env['rack.session'][:csrf]
    path = req.env['PATH_INFO']
    method = req.env['REQUEST_METHOD']

    Rack::Attack::Allow2Ban.filter(uid, :maxretry => 3, :findtime => 1.minute, :bantime => 1.hour) do
      # The count for the user id is incremented if the return value is truthy.
      path = '/registro' && method == 'post'
    end
  end
end


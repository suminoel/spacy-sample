class Rack::Attack
  Rack::Attack.blocklist('only allow from office') do |req|
    req.path.match(%r{^/users/sign_up}) && (ENV['OFFICE_IP_ADDRESS'] != req.ip)
  end
end
require 'httparty'
require 'json'


class Kele
  include HTTParty

  def api_uri
    'https://www.bloc.io/api/v1'
  end

  def initialize(email, password)
    response = self.class.post("#{api_uri}/sessions", body: { "email": email, "password": password })
    if response.code == 404
      puts "Sorry, Invalid email or password"
    end
    @auth_token = response['auth_token']
  end
end

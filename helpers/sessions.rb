require 'securerandom'
require 'httparty'

helpers do
  def current_github_username
    session[:github_user][:login]
  end

  def authenticated?
    !session[:github_user].blank?
  end

  def logout!
    session.delete :github_user
  end

  def authenticate!
    return if authenticated?

    session['github_oauth_check_state'] = SecureRandom.hex

    oauth_params = {
        :client_id => ENV['GITHUB_CLIENT_ID'],
        :redirect_uri => request.base_url + "/auth/callback",
        :scope => 'user',
        :state => session['github_oauth_check_state']
    }

    redirect 'https://github.com/login/oauth/authorize?' + hash_to_querystring(oauth_params)
  end

  def handle_github_callback
    github_state_check = params[:state]

    return false if github_state_check != session['github_oauth_check_state']

    github_code = params[:code]

    github_response = HTTParty.post('https://github.com/login/oauth/access_token',
                                    :body => {:client_id => ENV['GITHUB_CLIENT_ID'],
                                              :code => github_code,
                                              :client_secret => ENV['GITHUB_CLIENT_SECRET']},
                                    :headers => {"Accept" => "application/json"})

    if github_response.code == 200
      token_details = JSON.parse(github_response.body)

      user_lookup = HTTParty.get('https://api.github.com/user?', headers: {"Accept" => "application/json",
                                                                           "Authorization" => "token #{token_details['access_token']}",
                                                                           "User-Agent" => "stujo's app"
                                                               })


      set_current_github_user JSON.parse(user_lookup.body), token_details['access_token']
    else
      false
    end
  end

  def set_current_github_user github_user, auth_token
    session[:github_user] = {
        login: github_user['login'],
        avatar_url: github_user['avatar_url'],
        html_url: github_user['html_url'],
        auth_token: auth_token
    }
    true
  end


  #borrowed from http://justanothercoder.wordpress.com/2009/04/24/converting-a-hash-to-a-query-string-in-ruby/
  def hash_to_querystring(hash)
    hash.keys.inject('') do |query_string, key|
      query_string << '&' unless key == hash.keys.first
      query_string << "#{URI.encode(key.to_s)}=#{URI.encode(hash[key])}"
    end
  end

end
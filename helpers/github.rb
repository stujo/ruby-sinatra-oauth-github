helpers do
  def github_current_user_repos
    @github_current_user_repos ||= github_api_get("/users/#{current_github_username}/repos?" + hash_to_querystring('type' => 'owner',
                                                                                    'sort' => 'updated',
                                                                                    'direction' => 'desc')).map do |repo|
      repo['full_name']
    end
  end

  def github_api_get(api_path)
    response = HTTParty.get("https://api.github.com#{api_path}",
                            headers: {"Accept" => "application/json",
                                      "Authorization" => "token #{current_github_auth_token}",
                                      "User-Agent" => "stujo's app"
                            })
    JSON.parse(response.body)
  end

end
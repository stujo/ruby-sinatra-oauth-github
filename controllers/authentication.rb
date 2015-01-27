get '/login' do
  authenticate!
  redirect '/'
end

get '/logout' do
  logout!
  redirect '/'
end


get '/auth/callback' do
  redirect "/user/#{current_github_username}/notes" if handle_github_callback
  halt 401, "Unable to Authenticate Via GitHub"
end


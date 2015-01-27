before '/notes*' do
  authenticate!
end


get '/notes' do
  @notes = Note.all
  erb :"notes/index"
end

get '/notes/new' do
  @note = Note.new
  erb :"notes/new"
end

post '/notes' do
  @note = Note.new(params[:note])
  @note.github_username = current_github_username
  if @note.save
    redirect "/notes"
  else
    erb :"notes/new"
  end
end

get '/notes/:id' do
  @note = Note.find(params[:id])
  erb :"notes/show"
end

get '/notes/:id/edit' do
  @note = Note.find(params[:id])
  halt 401 unless @note.github_username == current_github_username
  erb :"notes/edit"
end

post '/notes/:id' do
  @note = Note.find(params[:id])
  halt 401 unless @note.github_username == current_github_username
  if @note.update_attributes(params[:note])
    redirect "/notes"
  else
    erb :"notes/edit"
  end
end

delete '/notes/:id' do
  @note = Note.find(params[:id])
  halt 401 unless @note.github_username == current_github_username
  @note.destroy
  redirect "/notes"
end


get '/user/:github_username/notes' do
  @github_username = params[:github_username]
  @notes = Note.where(:github_username => @github_username)
  erb :"users/notes"
end


